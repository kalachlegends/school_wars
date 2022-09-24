defmodule User.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  def register_user(login, password) do
    if String.contains?(login, "№") do
      {:error, "login contains bad char"}
    else
      if Repo.one(
           from user in User,
             where: user.login == ^login
         ) != nil do
        {:error, "login already exists"}
      else
        Repo.insert(
          User.changeset(%User{}, %{
            login: login,
            hash: :crypto.hash(:sha224, password),
            data: %{},
            ratings: %Ratings{},
            roles: [],
            comment_ids: []
          })
        )
      end

      Repo.one(
        from user in User,
          where: user.login == ^login
      )
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
        {:ok, Session.write(%{account: user}).token}

      nil ->
        {:error, "no such user"}

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
        {:ok, "user deleted"}

      any ->
        any
    end
  end
end
