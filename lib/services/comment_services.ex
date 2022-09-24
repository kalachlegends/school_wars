defmodule Comment.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  def create(author_id, comment_data) do
    Repo.insert(
      Comment.changeset(%Comment{}, %{
        data: comment_data,
        ratings: %{"likes" => [], "dislikes" => []},
        author_id: author_id
      })
    )
  end

  def rate(comment_id, rate_type, user_id) do
    comment =
      Repo.one(
        from comment in Comment,
          where: comment.id == ^comment_id
      )

    if is_nil(comment) or is_nil(Repo.one(
      from user in User,
        where: user.id == ^user_id
    )) do
      {:error, "Такого комментария или пользователя не существует"}
    else
      rates = comment.ratings
      if user_id not in rates["likes"] and user_id not in rates["dislikes"] do
        Repo.update(
          Comment.changeset(comment, %{
            ratings: Map.put(rates, rate_type, rates[rate_type] ++ [user_id])
          })
        )
      else
        if user_id in rates[rate_type] do
          Repo.update(
            Comment.changeset(comment, %{
              ratings: Map.put(rates, rate_type, List.delete(rates[rate_type], user_id))
            })
          )
        else
          opposite = if rate_type == "likes", do: "dislikes", else: "likes"
          Repo.update(
            Comment.changeset(comment, %{
              ratings: Map.put(rates, opposite, List.delete(rates[opposite], user_id))
            })
          )
          rate(comment_id, rate_type, user_id)
        end
      end
    end
  end
end
