defmodule SchoolWarsWeb.TaskController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_task_send(conn, %{"task" => %{"html" => html_orig}}) do
    session = Session.read(get_session(conn, :token)).data
    user = session.account
    # ((?<!\\)<)|((?<!\\)>) Matches <> that have no \
    # (value=\\")(.*?)(\\") Matches text value
    values = Regex.scan(~r/(value=\")(.*?)(\")/, html_orig)
    |> Enum.map(&(Enum.at(&1, 2)))
    IO.inspect(values, label: "values")
    html_orig = String.replace(html_orig, ~r/(value=\")(.*?)(\")/, "")
    html_orig = String.replace(html_orig, ~r/(\r)(\n)( +)/, "")
    html_orig = String.replace(html_orig, " ,=\"\"", "")
    html = String.replace(html_orig, ~r/((<button)(.*?)(button>))|( onclick=\"selectQuestion\(event\.target\)\")/, "")
    #html = String.replace(html, "task-block", "")
    html = Regex.split(~r/((?<!\\)<)|((?<!\\)>)/, html, trim: true)
    {html, answers, _} = Enum.reduce(html, {"", [], values}, fn string, {acc, ans, values} ->
      cond do
        String.contains?(string, "div class=\"question\"") ->
          {acc <> "<" <> string <> ">", ans ++ [[]], values}
        String.contains?(string, "div") ->
          {acc <> "<" <> string <> ">", ans, values}
        String.contains?(string, "input type=\"radio\"") or String.contains?(string, "input type=\"checkbox\"") ->
          name = Regex.run(~r/(name=\")(.*?)(\")/, string)
          |> Enum.at(2)
          {last, list} = List.pop_at(ans, -1)
          count = length(last)
          last = last ++ [String.contains?(string, " checked=\"true\"")]
          string = String.replace(string, " checked=\"true\"", "")
          string = String.replace(string, ~r/(name=\")(.*?)(\")/, "name=\"answer[#{name}]\"")
          {acc <> "<" <> string <> "value=\"#{count}\"" <> ">", list ++ [last], values}
        String.contains?(string, "input type=\"text\" class=") ->
          {value, list} = List.pop_at(values, 0)
          {acc <> "<div class=\"question-text\">#{value}</div>", ans, list}
        String.contains?(string, "input type=\"text\"") ->
          name = Regex.run(~r/(name=\")(.*?)(\")/, string)
          |> Enum.at(2)
          {last, list} = List.pop_at(ans, -1)
          {value, list2} = List.pop_at(values, 0)
          last = last ++ [value]
          if String.contains?(acc, name) do
            {acc, list ++ [last], list2}
          else
            {acc <> "<input type=\"text\" ,=\"\" class=\"answer-input\" name=\"answer[#{name}]\" placeholder=\"Ваш ответ\" required=\"\"", list ++ [last], list2}
          end
        true ->
          IO.inspect(string, label: "string")
          {acc <> string, ans, values}
      end
    end)
    html = Regex.replace(~r/(<div class=\"answer-(closed|open|multiple)-adder\"><\/div>)/, html, "")
    #IO.inspect(html_orig, label: "uncompressed")
    #compress_original(html_orig)
    #|> IO.inspect(label: "compressed")
    {:ok, work} = Work.Services.create(user.id, %{editable: html_orig, values: values, front: html, answers: answers})
    |> IO.inspect()
    Session.update(get_session(conn, :token), Map.merge(session, %{group_id: work.id}))
    conn
    |> put_flash(:lol, html)
    |> render("create_task.html")
  end

  def create_task(conn, _) do
    render(conn, "create_task.html")
  end

  def edit_task_send(conn, _params) do
    render(conn, "create_task.html")
  end

  def edit_task(conn, _params) do
    render(conn, "create_task.html")
  end

  def all_taskes(conn, _params) do
    render(conn, "all_taskes.html")
  end

  def submit_answer(conn, _) do
    session = Session.read(get_session(conn, :token)).data
    IO.inspect(session, label: "session")
    render(conn, "all_taskes.html")
  end

  #defp compress_original(original) do
  #  String.replace(original, "<div class=\"question-container\" onclick=\"selectQuestion(event.target)\"><button class=\"deleter\" onclick=\"deleteQuestion(event)\">Удалить вопрос</button><div class=\"question\"><div class=\"question-number\">", "%@--+1")
  #end
end
