defmodule SchoolWarsWeb.TaskController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_task(conn, %{}) do
    render(conn, "create_task.html")
  end

  def create_task(conn, params) do
    IO.inspect(params)
    render(conn, "create_task.html")
  end
end
