defmodule SchoolWarsWeb.SchoolController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def news(conn, _params) do
    render(conn, "news.html")
  end

  def rating(conn, _params) do
    render(conn, "rating.html")
  end
end
