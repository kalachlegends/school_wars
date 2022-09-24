defmodule SchoolWarsWeb.TaskController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_task_send(conn, %{"task" => %{"html" => html}}) do
    IO.inspect(String.replace(html, ~r/(\\n|\\r|\\t|\ \ )/, ""))
    render(conn, "create_task.html")
  end

  def create_task(conn, _) do
    render(conn, "create_task.html")
  end

  def all_taskes(conn, _params) do
    render(conn, "all_taskes.html")
  end
end
