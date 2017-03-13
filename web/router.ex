defmodule Blaces.Router do
  use Blaces.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Blaces do
    pipe_through [:browser, :with_session]

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    # Authenticated user
    scope "/"  do
      pipe_through [:login_required]

      resources "/users", UserController, only: [:show]

      get "/yelp", YelpController, :index
      post "/yelp", YelpController, :index
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", Blaces do
    pipe_through :api

    get "/yelp", YelpController, :index
    post "/yelp", YelpController, :index
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Blaces.CurrentUser
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated,
         handler: Blaces.GuardianErrorHandler
  end

end
