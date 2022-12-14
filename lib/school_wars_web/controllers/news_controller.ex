defmodule SchoolWarsWeb.NewsController do
  use SchoolWarsWeb, :controller

  def news_editor(conn, _params) do
    render(conn, "news_editor.html")
  end

  def news_form(conn, params) do
    IO.inspect(params)
    token = get_session(conn, :token)
    data = Session.read(token)
    school = Enum.find(data.data.groups, &(&1.group_type == "school"))

    News.Services.insert_news(
      %{
        "title" => params["title"],
        "html" => params["html"],
        "description" => params["description"],
        "photo" => params["image"]
      },
      school.id
    )

    #https://static1.cbrimages.com/wordpress/wp-content/uploads/2022/01/Sirius-Black.jpg
    #Сбежал узник Азкабана
    #Узник Азкабана сбежал!
    #Сбежал узник Азкабана - Сириус Блэк

    conn
    |> put_flash(:info, "Успешно создано")
    |> redirect(to: Routes.news_path(conn, :news_editor))
  end
end
