defmodule SchoolWarsWeb.SchoolController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    
    render(conn, "index.html")
  end

  def news(conn, _params) do
    {:ok, news} = News.Services.get_news()
    render(conn, "news.html", news: news)
  end

  def rating(conn, _params) do
    render(conn, "rating.html")
  end
end
