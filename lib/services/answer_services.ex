defmodule Answer.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  def create(author_id, work_id, answer_data) do
    Repo.insert(
      Answer.changeset(%Answer{}, %{
        author_id: author_id,
        work_id: work_id,
        data: answer_data,
        ratings: %{"likes" => [], "dislikes" => []},
        comment_ids: []
      })
    )
  end

  def change_data(answer_id, data) do
    answer =
      Repo.one(
        from answer in Answer,
          where: answer.id == ^answer_id
      )

    if is_nil(answer) do
      {:error, "Такой работы не существует"}
    else
      Repo.update(
        Answer.changeset(answer, %{
          data: Map.merge(answer.data, data)
        })
      )
    end
  end

  def add_comment(answer_id, comment_id)
      when is_integer(answer_id) and is_integer(comment_id) do
    answer =
      Repo.one(
        from answer in Answer,
          where: answer.id == ^answer_id
      )

    if is_nil(answer) do
      {:error, "Такой работы не существует"}
    else
      Repo.update(
        Answer.changeset(answer, %{
          comment_ids: answer.comment_ids ++ [comment_id]
        })
      )
    end
  end

  def add_comment(_answer_id, _comment_id) do
    {:error, "Неверные входные данные"}
  end

  def rate(answer_id, rate_type, user_id) do
    answer =
      Repo.one(
        from answer in Answer,
          where: answer.id == ^answer_id
      )

    if is_nil(answer) or is_nil(Repo.one(
      from user in User,
        where: user.id == ^user_id
    )) do
      {:error, "Такого ответа или пользователя не существует"}
    else
      rates = answer.ratings
      if user_id not in rates["likes"] and user_id not in rates["dislikes"] do
        Repo.update(
          Answer.changeset(answer, %{
            ratings: Map.put(rates, rate_type, rates[rate_type] ++ [user_id])
          })
        )
      else
        if user_id in rates[rate_type] do
          Repo.update(
            Answer.changeset(answer, %{
              ratings: Map.put(rates, rate_type, List.delete(rates[rate_type], user_id))
            })
          )
        else
          opposite = if rate_type == "likes", do: "dislikes", else: "likes"
          Repo.update(
            Answer.changeset(answer, %{
              ratings: Map.put(rates, opposite, List.delete(rates[opposite], user_id))
            })
          )
          rate(answer_id, rate_type, user_id)
        end
      end
    end
  end
end
