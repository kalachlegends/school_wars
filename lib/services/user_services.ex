defmodule User.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  def register_user(login, password) do
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

  def make_school_rep(user) do
    User.changeset(user, %{
      data: %{roles: user.roles ++ ["school_rep"]}
    })
    |> Repo.update()
  end

  def rate(user_id_receiver, rate_type, user_id) do
    user =
      Repo.one(
        from user in User,
          where: user.id == ^user_id_receiver
      )

    if is_nil(user) or is_nil(Repo.one(
      from user in User,
        where: user.id == ^user_id
    )) do
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
