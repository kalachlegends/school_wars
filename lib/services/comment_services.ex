defmodule Comment.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  #def create_comment()

  def rate(group_id, rate_type, user_id) do
    group =
      Repo.one(
        from group in Comment,
          where: group.id == ^group_id
      )

    if is_nil(group) do
      {:error, "Такой группы не существует"}
    else
      rates = group.ratings
      if user_id not in rates["likes"] and user_id not in rates["dislikes"] do
        Repo.update(
          Comment.changeset(group, %{
            ratings: Map.put(rates, rate_type, rates[rate_type] ++ [user_id])
          })
        )
      else
        if user_id in rates[rate_type] do
          Repo.update(
            Comment.changeset(group, %{
              ratings: Map.put(rates, rate_type, List.delete(rates[rate_type], user_id))
            })
          )
        else
          opposite = if rate_type == "likes", do: "dislikes", else: "likes"
          Repo.update(
            Comment.changeset(group, %{
              ratings: Map.put(rates, opposite, List.delete(rates[opposite], user_id))
            })
          )
          rate(group_id, rate_type, user_id)
        end
      end
    end
  end
end
