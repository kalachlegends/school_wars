defmodule News.Services do
  import Ecto.Query
  alias SchoolWars.Repo


  def insert_news(content, group_id) when is_map(content) and is_integer(group_id) do
    Repo.insert(
      News.changeset(%News{}, %{
        content: content,
        group_id: group_id,
        rating: %{"likes" => 0, "dislikes" => 0}
      })
    )
  end
  
  def insert_news(_content, _group_id) do
    {:error, "Неправильная форма заполнения или не существует такой школы."}
  end

  def news_query do
    from(
      news in News,
      select: news
    )
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

  def get_news(nil) do
    case Repo.all(news_query()) do
      {:error, reason} ->
        {:error, reason}

      list ->
        {:ok, list}
    end
  end
end
