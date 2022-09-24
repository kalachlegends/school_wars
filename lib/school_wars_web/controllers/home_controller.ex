defmodule SchoolWarsWeb.HomeController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def uikit(conn, params) do
    render(conn, "uikit.html")
  end
end
