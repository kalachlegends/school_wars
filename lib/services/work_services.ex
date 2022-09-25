defmodule Work.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  def get_by_filter(user_id, status \\ "")

  def get_by_filter(user_id, status) when is_integer(user_id) and is_bitstring(status) do
    from(
      work in Work,
      where: work.author_id == ^user_id and work.status == ^status,
      select: work
    )
    |> Repo.all()
  end

  def get_by_filter(_user_id, _status) do
    {:error, "Неправильный формат данных."}
  end

  def create(author_id, work_data) do
    Repo.insert(
      Work.changeset(%Work{}, %{
        status: "alpha",
        author_id: author_id,
        data: work_data,
        ratings: %{"likes" => [], "dislikes" => []},
        answer_ids: [],
        comment_ids: []
      })
    )
  end

  def get_by_id(id) do
    Repo.one(
      from work in Work,
        where: work.id == ^id
    )
  end

  @spec get_all_except_done_by_user_id(any) :: any
  def get_all_except_done_by_user_id(user_id) do
    work_ids = Repo.all(
      from answer in Answer,
        where:  answer.author_id == ^user_id
    )
    |> Enum.map(&(&1.work_id))
    Repo.all(
      from work in Work,
        where: work.id not in ^work_ids and work.author_id != ^user_id
    )
  end

  def change_data(work_id, data) do
    work =
      Repo.one(
        from work in Work,
          where: work.id == ^work_id
      )

    if is_nil(work) do
      {:error, "Такой работы не существует"}
    else
      Repo.update(
        Work.changeset(work, %{
          data: Map.merge(work.data, data)
        })
      )
    end
  end

  def change_status(work_id, status) do
    work =
      Repo.one(
        from work in Work,
          where: work.id == ^work_id
      )

    if is_nil(work) do
      {:error, "Такой работы не существует"}
    else
      Repo.update(
        Work.changeset(work, %{
          status: status
        })
      )
    end
  end

  def add_comment(work_id, comment_id)
      when is_integer(work_id) and is_integer(comment_id) do
    work =
      Repo.one(
        from work in Work,
          where: work.id == ^work_id
      )

    if is_nil(work) do
      {:error, "Такой работы не существует"}
    else
      Repo.update(
        Work.changeset(work, %{
          comment_ids: work.comment_ids ++ [comment_id]
        })
      )
    end
  end

  def add_comment(_work_id, _comment_id) do
    {:error, "Неверные входные данные"}
  end

  def add_answer(work_id, answer_id)
      when is_integer(work_id) and is_integer(answer_id) do
    work =
      Repo.one(
        from work in Work,
          where: work.id == ^work_id
      )

    if is_nil(work) do
      {:error, "Такой работы не существует"}
    else
      Repo.update(
        Work.changeset(work, %{
          answer_ids: work.answer_ids ++ [answer_id]
        })
      )
    end
  end

  def add_answer(_work_id, _answer_id) do
    {:error, "Неверные входные данные"}
  end

  def rate(work_id, rate_type, user_id) do
    work =
      Repo.one(
        from work in Work,
          where: work.id == ^work_id
      )

    if is_nil(work) or
         is_nil(
           Repo.one(
             from user in User,
               where: user.id == ^user_id
           )
         ) do
      {:error, "Такой работы или пользователя не существует"}
    else
      rates = work.ratings

      if user_id not in rates["likes"] and user_id not in rates["dislikes"] do
        Repo.update(
          Work.changeset(work, %{
            ratings: Map.put(rates, rate_type, rates[rate_type] ++ [user_id])
          })
        )
      else
        if user_id in rates[rate_type] do
          Repo.update(
            Work.changeset(work, %{
              ratings: Map.put(rates, rate_type, List.delete(rates[rate_type], user_id))
            })
          )
        else
          opposite = if rate_type == "likes", do: "dislikes", else: "likes"

          Repo.update(
            Work.changeset(work, %{
              ratings: Map.put(rates, opposite, List.delete(rates[opposite], user_id))
            })
          )

          rate(work_id, rate_type, user_id)
        end
      end
    end
  end
end
