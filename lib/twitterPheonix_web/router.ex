defmodule TwitterPheonixWeb.Router do
  use TwitterPheonixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TwitterPheonixWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/text", PageController, :displayText
    get "/users/:id", PageController, :show  end

  # Other scopes may use custom stacks.
  # scope "/api", TwitterPheonixWeb do
  #   pipe_through :api
  # end
end
