defmodule Group.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  def create_group(name, manager_id, group_type, group_data \\ %Group.Data{})

  def create_group(name, manager_id, group_type, group_data)
      when is_bitstring(name) and is_integer(manager_id) and is_struct(group_data) do
    Repo.insert(
      Group.changeset(%Group{}, %{
        name: name,
        data: group_data,
        manager_id: manager_id,
        group_type: group_type,
        ratings: %Ratings{},
        user_ids: [manager_id],
        comment_ids: []
      })
    )
  end

  def create_group(_name, _manager_id, _group_type, _group_data) do
    {:error, "Неверные входные данные"}
  end

  def add_users_to_group(group_id, user_ids) when is_list(user_ids) and is_integer(group_id) do
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

  def add_users_to_group(_group_id, _user_ids) do
    {:error, "Неверные входные данные"}
  end

  def add_comment_to_group(group_id, comment_id)
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

  def add_comment_to_group(_group_id, _comment_id) do
    {:error, "Неверные входные данные"}
  end

  def change_group_data(group_id, data) when is_integer(group_id) and is_map(data) do
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

  def change_group_data(_group_id, _data) do
    {:error, "Неверные входные данные"}
  end
end
