defmodule SchoolWarsWeb.TaskController do
  use SchoolWarsWeb, :controller

    # 0 - alpha(можно редактировать, доступно модераторам), 1 - beta(можно редактитровать, доступно всем),
    # 2 - completed(нельзя редактировать, доступно всем), 3 - (можно редактировать, доступно модераторам)

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
