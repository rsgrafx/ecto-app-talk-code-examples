defmodule SmokeShopWeb.Router do
  use SmokeShopWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SmokeShopWeb do
    # Use the default browser stack
    pipe_through(:browser)
    resources("/products", ProductController)
    resources("/users", UserController)
    resources("/orders", OrderController)
    get("/", PageController, :index)
    get("/logout", PageController, :logout)
  end

  # Other scopes may use custom stacks.
  # scope "/api", SmokeShopWeb do
  #   pipe_through :api
  # end
end
