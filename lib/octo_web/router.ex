defmodule OctoWeb.Router do
  use OctoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug OctoWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OctoWeb do
    pipe_through :browser
    get "/", PageController, :index
    resources "/customers", CustomerController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", OctoWeb do
  #   pipe_through :api
  # end
end
