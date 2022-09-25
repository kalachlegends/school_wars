defmodule SchoolWarsWeb.NewsController do
  use SchoolWarsWeb, :controller

  def news_editor(conn, _params) do
    render(conn, "news_editor.html")
  end
end
