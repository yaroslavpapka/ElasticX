defmodule ArticleAppWeb.Router do
  use ArticleAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ArticleAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ArticleAppWeb do
    pipe_through :browser

    live "/", ArticleLive.Index, :index
    live "/new", ArticleLive.Index, :new
    live "/:id/edit", ArticleLive.Index, :edit
    live "/:id/", ArticleLive.Show, :show
    live "/:id/show/edit", ArticleLive.Show, :edit

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", ArticleAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:article_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ArticleAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
