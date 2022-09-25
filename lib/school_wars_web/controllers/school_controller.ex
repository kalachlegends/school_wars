defmodule SchoolWarsWeb.SchoolController do
  use SchoolWarsWeb, :controller

  def index(conn, _params) do
    school =
      Enum.find(Session.read(get_session(conn, :token)).data.groups, &(&1.group_type == "school"))

    render(conn, "index.html",
      school: school,
      users: User.Services.get_by_params(school.user_ids, "teacher")
    )
  end

  def news(conn, _params) do
    IO.inspect(get_session(conn))

    group_id =
      Enum.find(Session.read(get_session(conn, :token)).data.groups, &(&1.group_type == "school")).id

    {:ok, news} = News.Services.get_news(group_id)
    render(conn, "news.html", news: news)
  end

  def one_news_display(conn, params) do
    news_id = String.to_integer(params["news_id"])
    {:ok, news} = News.Services.get_by_id(news_id)
    render(conn, "one_news.html", news: news)
  end

  def rating(conn, _params) do
    render(conn, "rating.html")
  end
end
