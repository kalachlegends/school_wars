defmodule News.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  def insert_news(data, group_id) when is_integer(group_id) and is_map(data) do
    Repo.insert(
      News.changeset(%News{}, %{
        data: data,
        group_id: group_id,
        ratings: %{"likes" => [], "dislikes" => []},
        rated_users: []
      })
    )
  end

  def insert_news(_content, _group_id, _data) do
    {:error, "Неправильная форма заполнения или не существует такой школы."}
  end

  def update_news(data, news_id) when is_integer(news_id) and is_map(data) do
    case get_by_id(news_id) do
      {:ok, struct} ->
        data_to_update = Map.merge(struct.data, data)
        Repo.update(Ecto.Changeset.change(struct, data: data_to_update))
      {:error, reason} ->
        {:error, reason}
    end
  end

  def update_news(_data, _news_id) do
    {:error, "Неверны  формат даных."}
  end

  def news_query do
    from(
      news in News,
      select: news
    )
  end

  def get_by_id(news_id) when is_integer(news_id) do
    case Repo.one(where(news_query(), [news], news.id == ^news_id)) do
      {:error, reason} ->
        {:error, reason}

      struct ->
        {:ok, struct}
    end
  end

  def get_by_id(_news_id) do
    {:error, "Неправильный формат news_id."}
  end

  def get_news(group_id) when is_integer(group_id) do
    query = where(news_query(), [news], news.group_id == ^group_id)

    case Repo.all(query) do
      {:error, reason} ->
        {:error, reason}

      list ->
        {:ok, list}
    end
  end

  def get_news() do
    case Repo.all(news_query()) do
      {:error, reason} ->
        {:error, reason}

      list ->
        {:ok, list}
    end
  end

  def rate(news_id, rate_type, user_id) do
    news =
      Repo.one(
        from news in News,
          where: news.id == ^news_id
      )

    if is_nil(news) or
         is_nil(
           Repo.one(
             from user in User,
               where: user.id == ^user_id
           )
         ) do
      {:error, "Такой новости или пользователя не существует"}
    else
      rates = news.ratings

      if user_id not in rates["likes"] and user_id not in rates["dislikes"] do
        Repo.update(
          News.changeset(news, %{
            ratings: Map.put(rates, rate_type, rates[rate_type] ++ [user_id])
          })
        )
      else
        if user_id in rates[rate_type] do
          Repo.update(
            News.changeset(news, %{
              ratings: Map.put(rates, rate_type, List.delete(rates[rate_type], user_id))
            })
          )
        else
          opposite = if rate_type == "likes", do: "dislikes", else: "likes"

          Repo.update(
            News.changeset(news, %{
              ratings: Map.put(rates, opposite, List.delete(rates[opposite], user_id))
            })
          )

          rate(news_id, rate_type, user_id)
        end
      end
    end
  end
end
