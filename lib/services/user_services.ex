defmodule User.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  def register_user(login, password) do
    if Repo.one(
        from user in User,
          where: user.login == ^login
      ) != [] do
      {:error, "login already exists"}
    else
      Repo.insert(User.changeset(%User{}, %{login: login, hash: :crypto.hash(:sha224, password), data: %{}, comments: []}))
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

  def delete_user(login, password) do
    hash = :crypto.hash(:sha224, password)
    new_login = "DELETED_USER№" <> to_string(DateTime.utc_now() |> DateTime.to_unix())
    from(user in User,
      where: user.login == ^login and user.hash == ^hash,
      update: [set: [login: ^new_login, hash: <<0>>]])
    |> Repo.update_all([])
    |> case do
      {1, nil} ->
        {:ok, "user deleted"}
      any ->
        any
    end
  end
end
