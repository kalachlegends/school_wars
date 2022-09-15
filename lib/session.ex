defmodule Session do
  defstruct data: nil, token: nil, token_age: nil, token_max_age: nil

  @token_max_age 3600 * 24
  @table_name :session
  @table_struct [:user_token, :user_data, :date_time]

  use GenServer

  alias :mnesia, as: Mnesia

  def init(_state) do
    schedule_work()

    {:ok, []}
  end

  def start_link(state \\ []) do
    Mnesia.stop()
    Mnesia.create_schema([node()])
    Mnesia.start()

    Mnesia.create_table(@table_name, attributes: @table_struct, disc_copies: [node()])

    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def write(data) when is_map(data) do
    secret_key = Ecto.UUID.generate()
    salt = Ecto.UUID.generate()
    token = Phoenix.Token.encrypt(secret_key, salt, %{}, key_digest: :sha512)
    token_age = System.system_time(:second) + @token_max_age

    Mnesia.transaction(fn -> Mnesia.write({@table_name, token, data, token_age}) end)

    %__MODULE__{
      token: token,
      token_max_age: @token_max_age,
      token_age: token_age,
      data: data
    }
  end

  def read(token) do
    token
    |> match_mnesia()
    |> case do
      nil ->
        nil

      %__MODULE__{} = session ->
        {:ok, updated} = update(session.token, session.data)

        updated
    end
  end

  def update(token, data) do
    token
    |> match_mnesia()
    |> case do
      %__MODULE__{} = old_session ->
        token_age = System.system_time(:second) + @token_max_age

        Mnesia.transaction(fn ->
          Mnesia.write({@table_name, old_session.token, data, token_age})
        end)
        |> case do
          {:atomic, :ok} -> {:ok, %__MODULE__{old_session | data: data, token_age: token_age}}
          _ -> {:error, "session not found"}
        end

      nil ->
        {:error, "session not found"}
    end
  end

  def delete(token) do
    match_mnesia(token)
    |> case do
      nil ->
        {:error, "session not found"}

      %__MODULE__{} = session ->
        Mnesia.transaction(fn -> Mnesia.delete({@table_name, session.token}) end)
        |> case do
          {:atomic, :ok} -> {:ok, "session deleted"}
          _ -> {:error, "session not found"}
        end
    end
  end

  def handle_info(:clear_old_sessions, state) do
    Mnesia.transaction(fn ->
      Mnesia.select(@table_name, [
        {{@table_name, :"$1", :"$2", :"$3"}, [{:<, :"$3", System.system_time(:second)}], [:"$$"]}
      ])
    end)
    |> case do
      {:atomic, []} -> []
      {:atomic, items} -> items
    end
    |> Enum.map(fn [id, _, _] ->
      Mnesia.transaction(fn -> Mnesia.delete({@table_name, id}) end)
    end)

    schedule_work()

    {:noreply, state}
  end

  defp match_mnesia(token) do
    Mnesia.transaction(fn -> Mnesia.match_object({@table_name, token, :_, :_}) end)
    |> case do
      {:atomic, []} ->
        nil

      {:atomic, items} ->
        {@table_name, token, data, token_age} = hd(items)

        if token_age >= System.system_time(:second) do
          %__MODULE__{
            data: data,
            token: token,
            token_age: token_age,
            token_max_age: @token_max_age
          }
        else
          nil
        end
    end
  end

  defp schedule_work, do: Process.send_after(self(), :clear_old_sessions, @token_max_age * 1000)
end

defmodule Session.Plug do
  import Plug.Conn

  def init(_opts), do: {:ok, []}

  def call(conn, _opts) do
    Session.read(get_session(conn, :token))
    |> case do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: SchoolWarsWeb.Router.Helpers.page_path(conn, :index))
        |> halt()

      _ ->
        conn
    end
  end
end

defmodule Session.PlugAdmin do
  import Plug.Conn
  import Ecto.Query
  alias SchoolWars.Repo

  def init(_opts), do: {:ok, []}

  def call(conn, _opts) do
    Session.read(get_session(conn, :token))
    |> case do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: SchoolWarsWeb.Router.Helpers.page_path(conn, :index))
        |> halt()

      data ->
        roles = data.data.account.data["roles"]
        if "admin" in roles do
          conn
        else
          conn
          |> Phoenix.Controller.redirect(to: SchoolWarsWeb.Router.Helpers.page_path(conn, :index))
          |> halt()
        end
    end
  end
end
