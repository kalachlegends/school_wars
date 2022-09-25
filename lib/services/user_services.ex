defmodule User.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  @user_data %{
    "photo" => "/images/teacher.png",
    "description" => "У этого пользователя нет описания.",
    "history" => "У этого пользователя нет истории.",
    "specialty" => "Математика",
    "work_experience" => 0,
    "name" => "Михайл",
    "middle_name" => "Петрович",
    "surname" => "Зубенко"
  }

  def register_user(login, password, roles \\ []) do
    if String.contains?(login, "№") do
      {:error, "В логине находится знак №"}
    else
      if Repo.one(
           from user in User,
             where: user.login == ^login
         ) != nil do
        {:error, "Логин уже существует"}
      else
        Repo.insert(
          User.changeset(%User{}, %{
            login: login,
            hash: :crypto.hash(:sha224, password),
            data: %{},
                        ratings: %{"likes" => [], "dislikes" => []},
            roles: roles,
            comment_ids: []
          })
        )

        Repo.one(
          from user in User,
            where: user.login == ^login
        )
      end
    end
  end

  def register_user_random_pass(login, data, roles \\ []) do
    password = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')>>
    if String.contains?(login, "№") do
      {:error, "В логине находится знак №"}
    else
      if Repo.one(
           from user in User,
             where: user.login == ^login
         ) != nil do
        {:error, "Логин уже существует"}
      else
        Repo.insert(
          User.changeset(%User{}, %{
            login: login,
            hash: :crypto.hash(:sha224, password),
            data: data,
            ratings: %{"likes" => [], "dislikes" => []},
            roles: roles,
            comment_ids: []
          })
        )
        |> case do
          {:ok, _} ->
            {Repo.one(
              from user in User,
                where: user.login == ^login
            ), password}
          any ->
            any
        end
      end
    end
  end

  def login_user(login, password) do
    hash = :crypto.hash(:sha224, password)

    Repo.one(
      from user in User,
        where: user.login == ^login and user.hash == ^hash
    )
    |> case do
      %User{} = user ->
        groups =
          Repo.all(
            from group in Group,
              where: ^user.id in group.user_ids
          )

        {:ok, Session.write(%{account: user, groups: groups}).token}

      nil ->
        {:error, "Такого пользователя не существует"}

      any ->
        any
    end
  end

  def logout_user(token) do
    Session.delete(token)
  end

  def delete_user(token, login, password) do
    if token != nil do
      Session.delete(token)
    end

    hash = :crypto.hash(:sha224, password)
    new_login = "DELETED_USER№" <> to_string(DateTime.utc_now() |> DateTime.to_unix())

    from(user in User,
      where: user.login == ^login and user.hash == ^hash,
      update: [set: [login: ^new_login, hash: <<0>>]]
    )
    |> Repo.update_all([])
    |> case do
      {1, nil} ->
        {:ok, "Пользователь удалён"}

      any ->
        any
    end
  end

  def add_role(user, role) do
    User.changeset(user, %{
      roles: user.roles ++ [role]
    })
    |> Repo.update()
  end

  def get_by_id(user_id) when is_integer(user_id) do
    from(
      user in User,
      where: user.id == ^user_id,
      select: user
    )
    |> Repo.one()
  end

  def update_data(data, user_id) when is_map(data) and is_integer(user_id) do
    case get_by_id(user_id) do
      {:error, reason} ->
        {:error, reason}

      user ->
        data_to_change = Map.merge(user.data, data)
        Repo.update(User.changeset(user, %{data: data_to_change}))
    end
  end

  def get_by_params(list, role \\ "")

  def get_by_params(list, role) when is_list(list) and is_bitstring(role) do
    query =
      from(
        user in User,
        where: user.id in ^list,
        select: user
      )

    if role == "" do
      query
    else
      where(query, [user], ^role in user.roles)
    end
    |> Repo.all()
  end

  def get_by_params(_list, _role) do
    {:error, "Неправильные входные данные."}
  end

  def rate(user_id_receiver, rate_type, user_id) do
    user =
      Repo.one(
        from user in User,
          where: user.id == ^user_id_receiver
      )

    if is_nil(user) or
         is_nil(
           Repo.one(
             from user in User,
               where: user.id == ^user_id
           )
         ) do
      {:error, "Такого пользователя не существует"}
    else
      rates = user.ratings

      if user_id not in rates["likes"] and user_id not in rates["dislikes"] do
        Repo.update(
          User.changeset(user, %{
            ratings: Map.put(rates, rate_type, rates[rate_type] ++ [user_id])
          })
        )
      else
        if user_id in rates[rate_type] do
          Repo.update(
            User.changeset(user, %{
              ratings: Map.put(rates, rate_type, List.delete(rates[rate_type], user_id))
            })
          )
        else
          opposite = if rate_type == "likes", do: "dislikes", else: "likes"

          Repo.update(
            User.changeset(user, %{
              ratings: Map.put(rates, opposite, List.delete(rates[opposite], user_id))
            })
          )

          rate(user_id_receiver, rate_type, user_id)
        end
      end
    end
  end
end
