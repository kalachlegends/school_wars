defmodule Group.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  def create(name, manager_id, group_type, group_data \\ %{})

  def create(name, manager_id, group_type, group_data)
      when is_bitstring(name) and is_integer(manager_id) and is_map(group_data) and
             is_bitstring(group_type) do
    Repo.insert(
      Group.changeset(%Group{}, %{
        name: name,
        data: group_data,
        manager_id: manager_id,
        group_type: group_type,
        ratings: %{"likes" => [], "dislikes" => []},
        user_ids: [manager_id],
        comment_ids: []
      })
    )
  end

  def create(_name, _manager_id, _group_type, _group_data) do
    {:error, "Неверные входные данные"}
  end

  def get_by_id(id) do
    Repo.one(
      from group in Group,
        where: group.id == ^id
    )
  end

  def add_users(group_id, user_ids) when is_list(user_ids) and is_integer(group_id) do
    group =
      Repo.one(
        from group in Group,
          where: group.id == ^group_id
      )

    if is_nil(group) do
      {:error, "Такой группы не существует"}
    else
      Repo.update(
        Group.changeset(group, %{
          user_ids: group.user_ids ++ user_ids
        })
      )
    end
  end

  def add_users(_group_id, _user_ids) do
    {:error, "Неверные входные данные"}
  end

  def add_comment(group_id, comment_id)
      when is_integer(group_id) and is_integer(comment_id) do
    group =
      Repo.one(
        from group in Group,
          where: group.id == ^group_id
      )

    if is_nil(group) do
      {:error, "Такой группы не существует"}
    else
      Repo.update(
        Group.changeset(group, %{
          comment_ids: group.comment_ids ++ [comment_id]
        })
      )
    end
  end

  def add_comment(_group_id, _comment_id) do
    {:error, "Неверные входные данные"}
  end

  def change_data(group_id, data) when is_integer(group_id) and is_map(data) do
    group =
      Repo.one(
        from group in Group,
          where: group.id == ^group_id
      )

    if is_nil(group) do
      {:error, "Такой группы не существует"}
    else
      Repo.update(
        Group.changeset(group, %{
          data: Map.merge(group.data, data)
        })
      )
    end
  end

  def change_data(_group_id, _data) do
    {:error, "Неверные входные данные"}
  end

  def rate(group_id, rate_type, user_id) do
    group =
      Repo.one(
        from group in Group,
          where: group.id == ^group_id
      )

    if is_nil(group) or is_nil(Repo.one(
      from user in User,
        where: user.id == ^user_id
    )) do
      {:error, "Такой группы или пользователя не существует"}
    else
      rates = group.ratings
      if user_id not in rates["likes"] and user_id not in rates["dislikes"] do
        Repo.update(
          Group.changeset(group, %{
            ratings: Map.put(rates, rate_type, rates[rate_type] ++ [user_id])
          })
        )
      else
        if user_id in rates[rate_type] do
          Repo.update(
            Group.changeset(group, %{
              ratings: Map.put(rates, rate_type, List.delete(rates[rate_type], user_id))
            })
          )
        else
          opposite = if rate_type == "likes", do: "dislikes", else: "likes"
          Repo.update(
            Group.changeset(group, %{
              ratings: Map.put(rates, opposite, List.delete(rates[opposite], user_id))
            })
          )
          rate(group_id, rate_type, user_id)
        end
      end
    end
  end
end
