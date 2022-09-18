defmodule SchoolWarsWeb.UserController do
  use SchoolWarsWeb, :controller

  def login_submit(conn, params) do
    login = params["login"]
    password = params["password"]

    case User.Services.login_user(login, password) do
      {:ok, token} ->
        conn
        |> put_session(:token, token)
        |> put_flash(:info, "Вы успешно авторизованы!")
        |> redirect(to: Routes.home_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Не верный пароль или логин")
        |> redirect(to: Routes.page_path(conn, :login))
    end
  end
end
