defmodule SchoolWarsWeb.SchoolController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def news(conn, _params) do
    render(conn, "news.html")
  end
end
