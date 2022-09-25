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

  def manager(conn, _params) do
    render(conn, "manager.html")
  end
end
