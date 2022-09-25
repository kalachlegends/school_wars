defmodule SchoolWarsWeb.ManagerController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  # def create_task_send(conn, %{"task" => %{"html" => html}}) do
  #   IO.inspect(String.replace(html, ~r/(\\n|\\r|\\t|\ \ )/, ""))
  #   render(conn, "create_task.html")
  # end

  # def create_task(conn, _) do
  #   render(conn, "create_task.html")
  # end

  def panel(conn, _params) do
    user = Session.read(get_session(conn, :token)).data.account
    school_name = Group.Services.get_by_manager_id(user.id).name
    render(conn, "manager.html", school_name: school_name)
  end

  def new_student(conn,params) do
    IO.inspect(params)
    conn
    |> put_flash(:ok, "Менеджер добавлен.")
    |> redirect(to: "/manager/panel")
  end
end
