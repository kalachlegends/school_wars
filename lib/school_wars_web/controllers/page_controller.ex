defmodule SchoolWarsWeb.PageController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def news(conn, _params) do
    {:ok, news} = News.Services.get_news(1)

    render(conn, "news.html", news: news)
  end

  # def index_token(conn, _params) do
  #   conn
  #   |> put_flash(:info, Session.read(get_session(conn, :token)).data.account.login)
  #   |> render("index.html", data: Session.read(get_session(conn, :token)).data)
  # end

  def login(conn, _params) do
    conn
    |> put_root_layout({SchoolWarsWeb.LayoutView, "clean.html"})
    |> render("login.html")
  end

  def rating(conn, params) do
    list = Group.Services.get_all()

    render(conn, "rating.html", schools: list)
  end
end
