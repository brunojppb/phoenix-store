defmodule MangoWeb.Router do
  use MangoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # Frontend related plugs
  pipeline :frontend do
    plug MangoWeb.Plugs.Locale
    plug MangoWeb.Plugs.LoadCustomer
    plug MangoWeb.Plugs.FetchCart
  end

  pipeline :admin do
    plug MangoWeb.Plugs.AdminLayout
    plug MangoWeb.Plugs.LoadAdmin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MangoWeb do
    pipe_through [:browser, :frontend]

    get "/", PageController, :index

    get "/login", SessionController, :new
    post "/login", SessionController, :create

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get "/categories/:name", CategoryController, :show

    post "/cart", CartController, :add
    get "/cart", CartController, :show
    put "/cart", CartController, :update
  end

  # Only autenticated users here
  scope "/", MangoWeb do
    pipe_through [:browser, :frontend, MangoWeb.Plugs.AuthenticateUser]

    get "/logout", SessionController, :delete
    get "/checkout", CheckoutController, :edit
    put "/checkout", CheckoutController, :update
    get "/orders", OrderController, :index
    get "/orders/:id", OrderController, :show

    resources "/tickets", TicketController, except: [:edit, :update, :delete]
  end

  scope "/admin", MangoWeb.Admin, as: :admin do
    pipe_through [:browser, :admin]

    get "/login", SessionController, :new
    post "/sendlink", SessionController, :send_link
    get "/sendlink", SessionController, :create
  end

  scope "/admin", MangoWeb.Admin, as: :admin do
    pipe_through [:browser, :admin, MangoWeb.Plugs.RequireAdminAuth]

    resources "/users", UserController
    get "/logout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", MangoWeb do
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
      live_dashboard "/dashboard", metrics: MangoWeb.Telemetry
    end
  end
end
