defmodule SchoolWarsWeb.Router do
  use SchoolWarsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SchoolWarsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :home_layout, do: plug(:put_root_layout, {SchoolWarsWeb.LayoutView, :home})

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :session_verify, do: plug(Session.Plug)
  pipeline :session_verify_admin, do: plug(Session.AdminPlug)
  pipeline :session_verify_manager, do: plug(Session.ManagerPlug)

  scope "/", SchoolWarsWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/login", PageController, :login
    post "/login", UserController, :login_submit
    get "/news", PageController, :news
  end

  scope "/", SchoolWarsWeb do
    pipe_through [:browser, :home_layout, :session_verify]

    get "/home", HomeController, :index
    get "/uikit", HomeController, :uikit

    get "/profile", UserController, :profile
    get "/profile/tasks", UserController, :tasks
    get "/logout", UserController, :logout

    get "/news_editor", NewsController, :news_editor

    post "/news_form", NewsController, :news_form

    post "/submit_answer", TaskController, :submit_answer

    scope "/school" do
      get "/", SchoolController, :index
      get "/news", SchoolController, :news
      get "/one_news", SchoolController, :one_news_display
      get "/workers", SchoolController, :news
    end
  end

  scope "/", SchoolWarsWeb do
    # pipe_through [:browser, :home_layout, :session_verify_school_rep]
    pipe_through [:browser, :home_layout, :session_verify]

    get "/tasks", TaskController, :manager

    get "/create_task", TaskController, :create_task
    post "/create_task", TaskController, :create_task_send

    post "/edit_task", TaskController, :edit_task
    post "/edit_task_send", TaskController, :edit_task_send
  end

  scope "/manager", SchoolWarsWeb do
    # pipe_through [:browser, :home_layout, :session_verify_school_rep]
    pipe_through [:browser, :home_layout, :session_verify_manager]

    get "/panel", ManagerController, :panel
    post "/new_student", ManagerController, :new_student

  end

  scope "/admin", SchoolWarsWeb do
    # pipe_through [:browser, :home_layout, :session_verify_school_rep]
    pipe_through [:browser, :home_layout, :session_verify_admin]

    get "/panel", AdminController, :panel
    post "/new_manager", AdminController, :new_manager
    post "/new_group", AdminController, :new_group

  end

  # Other scopes may use custom stacks.
  # scope "/api", SchoolWarsWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SchoolWarsWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
