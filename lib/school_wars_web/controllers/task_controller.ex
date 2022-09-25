defmodule SchoolWarsWeb.TaskController do
  use SchoolWarsWeb, :controller

    # 0 - alpha(можно редактировать, доступно модераторам), 1 - beta(можно редактитровать, доступно всем),
    # 2 - completed(нельзя редактировать, доступно всем), 3 - (можно редактировать, доступно модераторам)

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_task_send(conn, %{"task" => %{"html" => html_orig, "difficulty" => diff, "desc" => desc, "title" => title}}) do
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
          string = String.replace(string, ~r/(name=\")(.*?)(\")/, "name=\"answer[#{if String.contains?(string, "input type=\"checkbox\""), do: name <> "m#{count}", else: name}]\"")
          {acc <> "<" <> string <> "value=\"#{count}\"" <> (if String.contains?(string, "input type=\"checkbox\""), do: "", else: " required=\"true\"") <> ">", list ++ [last], values}
        String.contains?(string, "input type=\"text\" class=") ->
          {value, list} = List.pop_at(values, 0)
          {acc <> "<div class=\"question-text\">#{value}</div>", ans, list}
        String.contains?(string, "input type=\"text\"") ->
          name = Regex.run(~r/(name=\")(.*?)(\")/, string)
          |> Enum.at(2)
          {last, list} = List.pop_at(ans, -1)
          {value, list2} = List.pop_at(values, 0)
          last = last ++ [String.downcase(value)]
          if String.contains?(acc, name) do
            {acc, list ++ [last], list2}
          else
            {acc <> "<input type=\"text\" ,=\"\" class=\"answer-input\" name=\"answer[#{name}]\" placeholder=\"Ваш ответ\" required=\"true\"", list ++ [last], list2}
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
    {:ok, work} = Work.Services.create(user.id, %{editable: html_orig, values: values, front: html, answers: answers, difficulty: diff, desc: desc, title: title})
    |> IO.inspect()
    Session.update(get_session(conn, :token), Map.merge(session, %{work_id: work.id}))
    conn
    |> put_flash(:info, "Задача создана!")
    |> redirect(to: Routes.task_path(conn, :all_tasks))
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

  def do_task(conn, params) do
    IO.inspect(params)
    case Work.Services.get_by_id(String.to_integer(params["id"])) do
      nil ->
        conn
        |> put_flash(:error, "Такой задачи не существует")
        |> redirect(to: Routes.task_path(conn, :all_tasks))
      data ->
        render(conn, "do_task.html", data: %{html: data.data["front"], session: Session.read(get_session(conn, :token)).data, work_id: params["id"], token: get_session(conn, :token)})
    end
  end

  def all_tasks(conn, _params) do
    render(conn, "all_tasks.html", data: %{works: Work.Services.get_all_except_done_by_user_id(Session.read(get_session(conn, :token)).data.account.id)})
  end

  def submit_answer(conn, %{"answer" => answers}) do
    answers = Enum.reduce(answers, %{}, fn {key, value}, acc ->
      ans = Regex.run(~r/ans./, key)
      |> Enum.at(0)

      Map.put(acc, ans, Map.get(acc, ans, []) ++ [value])
    end)
    |> IO.inspect(label: "reduce")
    answers = Map.values(answers)
    session = Session.read(get_session(conn, :token)).data
    correct = Work.Services.get_by_id(session.work_id).data["answers"]
    answers = Enum.reduce(0..length(correct)-1, [], fn
      index, acc ->
        answer = Enum.at(answers, index)
        correct = Enum.at(correct, index)
        answer = if is_boolean(hd(correct)) do
          Enum.map(0..length(correct)-1, fn index ->
            to_string(index) in answer
          end)
        else
          String.downcase(hd(answer))
        end
        IO.inspect({answer, correct})
        acc ++ [(if is_boolean(hd(correct)), do: answer == correct, else: answer in correct)]
    end)

    {:ok, answer} = Answer.Services.create(session.account.id, session.work_id, %{answers: answers})
    Work.Services.add_answer(session.work_id, answer.id)

    conn
    |> put_flash(:info, "Вы получили #{Float.round(Enum.reduce(answers, 0, fn
      true, acc ->
        acc + 1
      false, acc ->
        acc
    end) / length(answers) * 100, 2)}%")
    |> redirect(to: Routes.task_path(conn, :all_tasks))
  end

  #defp compress_original(original) do
  #  String.replace(original, "<div class=\"question-container\" onclick=\"selectQuestion(event.target)\"><button class=\"deleter\" onclick=\"deleteQuestion(event)\">Удалить вопрос</button><div class=\"question\"><div class=\"question-number\">", "%@--+1")
  #end
end
