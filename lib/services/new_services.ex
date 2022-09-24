defmodule News.Services do
  import Ecto.Query
  alias SchoolWars.Repo

  def insert_news(content, group_id) do
    
  end

  def get_news(group_id) do
    query =
      from(
        news in News,
        select: news
      )

    query =
      if is_nil(group_id) do
        query
      else
        where(query, [news], news.group_id == ^group_id)
      end

    case Repo.all(query) do
      {:error, reason} ->
        {:error, reason}

      list ->
        {:ok, list}
    end
  end
end
