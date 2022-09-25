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

      {:error, "no such user"} ->
        conn
        |> put_flash(:error, "Не верный пароль или логин")
        |> redirect(to: Routes.page_path(conn, :login))

      any ->
        IO.inspect(any, label: "actual error")

        conn
        |> put_flash(:error, "Произошла серверная ошибка")
        |> redirect(to: Routes.page_path(conn, :login))
    end
  end

  def profile(conn, _params) do
    render(conn, "profile.html")
  end
end
