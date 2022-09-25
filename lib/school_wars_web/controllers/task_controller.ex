defmodule SchoolWarsWeb.TaskController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_task_send(conn, %{"task" => %{"html" => html}}) do
    html = String.replace(String.replace(html, "\r\n", ""), "  ", "")
    html = String.split(html, " onclick=\"selectQuestion(event.target)\"")
    html = Enum.reduce(html, "", fn
      string, acc ->
        cond do
          true ->
            string = String.replace(string, "<button onclick=\"addAnswer(event, 'multiple')\">Добавить ответ</button>", "")
            string = String.replace(string, "<button onclick=\"addAnswer(event, 'closed')\">Добавить ответ</button>", "")
            string = String.replace(string, "<button onclick=\"addAnswer(event, 'open')\">Добавить ответ</button>", "")
            string = String.replace(string, "<button class=\"deleter\" onclick=\"deleteAnswer(event)\">Удалить ответ</button>", "")
            string = String.replace(string, "<button class=\"deleter\" onclick=\"deleteQuestion(event)\">Удалить вопрос</button>", "")
            acc <> string
        end
    end)
    html = Regex.split(~r/<|>/, html, trim: true)
    {html, answers} = Enum.reduce(html, {"", []}, fn string, {acc, ans} ->
      cond do
        String.contains?(string, "div class=\"question\"") ->
          {acc <> "<" <> string <> ">", ans ++ [[]]}
        String.contains?(string, "div") ->
          {acc <> "<" <> string <> ">", ans}
        String.contains?(string, "input type=\"radio\" ,=\"\"") or String.contains?(string, "input type=\"checkbox\" ,=\"\"") ->
          string = String.replace(string, " checked=\"true\"", "")
          IO.inspect(string)
          {last, list} = List.pop_at(ans, -1)
          last = last ++ [String.contains?(string, " checked=\"true\"")]
          string = String.replace(string, " checked=\"true\"", "")
          {acc <> "<" <> string <> ">", list ++ [last]}
        String.contains?(string, "input type=\"text\" ,=\"\"") ->
          IO.inspect(string)
          {acc <> "<" <> string <> ">", ans}
        true ->
          {acc <> string, ans}
      end
    end)
    IO.inspect({html, answers})
    render(conn, "create_task.html")
  end

  def create_task(conn, _) do
    render(conn, "create_task.html")
  end

  def all_taskes(conn, _params) do
    render(conn, "all_taskes.html")
  end
end
