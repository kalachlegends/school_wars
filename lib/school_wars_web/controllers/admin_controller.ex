defmodule SchoolWarsWeb.AdminController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def panel(conn, _params) do
    Session.read(get_session(conn, :token)).data.account
    render(conn, "admin.html")
  end

  def new_manager(conn, params) do
    data = %{
      first_name: params["first_name"],
      last_name: params["last_name"],
      patronymic: params["patronymic"]
    }

    User.Services.register_user_random_pass(params["email"], data, ["manager"])

    conn
    |> put_flash(:ok, "Менеджер школы успешно добавлен")
    |> redirect(to: "/admin/panel")
  end
end
