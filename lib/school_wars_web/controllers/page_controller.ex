defmodule SchoolWarsWeb.PageController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  # def index_token(conn, _params) do
  #   conn
  #   |> put_flash(:info, Session.read(get_session(conn, :token)).data.account.login)
  #   |> render("index.html", data: Session.read(get_session(conn, :token)).data)
  # end
end
