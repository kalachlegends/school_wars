defmodule SchoolWarsWeb.ManagerController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def panel(conn, _params) do
    user = Session.read(get_session(conn, :token)).data.account
    school_name = Group.Services.get_by_manager_id(user.id).name
    render(conn, "manager.html", school_name: school_name)
  end

  def new_student(conn, params) do
    data = %{
      first_name: params["first_name"],
      last_name: params["last_name"],
      patronymic: params["patronymic"],
      class: params["class"]
    }

    role =
      case params["role"] do
        "0" -> [nil]
        "1" -> ["student"]
        "2" -> ["teacher"]
      end

    User.Services.register_user_random_pass(params["email"], data, role)

    conn
    |> put_flash(:ok, "Актор спешно добавлен")
    |> redirect(to: "/manager/panel")
  end
end
