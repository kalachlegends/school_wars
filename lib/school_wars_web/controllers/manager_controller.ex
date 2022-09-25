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
      name: params["first_name"],
      surname: params["last_name"],
      middle_name: params["patronymic"],
      specialty: params["class"],
      description: "У этого пользователя нет описания.",
      photo: "https://i.imgur.com/XoZjJrk.gif",
      work_experience: 20,
      history: "У этого пользователя нет истории."
    }

    role =
      case params["role"] do
        "0" -> [nil]
        "1" -> ["student"]
        "2" -> ["teacher"]
      end

    manager = Session.read(get_session(conn, :token)).data.account
    id = Group.Services.get_by_manager_id(manager.id).id

    user = User.Services.register_user(params["email"], "1234", data, role) |> IO.inspect()

    Group.Services.add_users(id, [user.id])

    conn
    |> put_flash(:ok, "Актор спешно добавлен")
    |> redirect(to: "/manager/panel")
  end
end
