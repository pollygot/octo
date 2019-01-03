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

  # guest zone
  scope "/", OctoWeb do
    pipe_through :browser
    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/customers", CustomerController, only: [:new, :create]
  end

  # registered user zone
  scope "/dashboard", OctoWeb.Dashboard, as: :dashboard do
    pipe_through [:browser, :authenticate_customer]
    resources "/", PageController, only: [:index]
    resources "/customers", CustomerController, except: [:new, :create]
    resources "/organizations", OrganizationController
  end

# I gotta put all the customers edit/update/delete somewhere
end
