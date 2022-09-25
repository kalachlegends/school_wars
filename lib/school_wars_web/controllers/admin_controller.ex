defmodule SchoolWarsWeb.AdminController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def panel(conn, _params) do
    Session.read(get_session(conn, :token)).data.account
    render(conn, "admin.html")
  end

  def new_school(conn, params) do
    data_manager = %{
      name: params["first_name"],
      surname: params["last_name"],
      middle_name: params["patronymic"],
      balls: "100",
      photo: params["photo"] || "priv/static/images/school-image.jpg"
    }

    

    User.Services.register_user(params["email"], params["pass"], data_manager, ["manager"])
    |> case do
      {:error, _any} ->
        conn
        |> put_flash(:error, "Не удалось создать менеджера")
        |> redirect(to: "/admin/panel")
      user ->
        manager_id = user.id
        name = params["name"]
        data_school = %{
          photo: params["photo"],
          history: params["history"],
          description: params["description"],
          school_direction: params["school_direction"],
          class_count: params["class_count"]
        }

        Group.Services.create(name, manager_id, "school", data_school)

        conn
        |> put_flash(:info, "Школа успешно создана")
        |> redirect(to: "/admin/panel")
    end
  end
end
