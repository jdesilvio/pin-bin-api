defmodule Blaces.Router do
  use Blaces.Web, :router

  ## Browser routing

  scope "/", Blaces do
    pipe_through [:browser, :with_session]

    get "/", PageController, :index
    get "/elm", ElmController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    # Authenticated user
    scope "/"  do
      pipe_through [:login_required]

      resources "/users", UserController, only: [:show] do
        resources "/buckets", BucketController
      end

      get "/yelp", YelpController, :index
      post "/yelp", YelpController, :index
    end
  end


  ## API routing

  scope "/api/v1", Blaces do
    pipe_through [:api]

    get "/yelp", YelpController, :index
    post "/yelp", YelpController, :index

    resources "/users", UserController, only: [:new, :create]

    post "/auth", AuthController, :show

    # Authenticated user
    scope "/"  do
      pipe_through [:api_auth, :login_required]

      resources "/users", UserController, only: [:show] do
        resources "/buckets", BucketController
      end
    end
  end


  ## Pipelines

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_auth do
    plug Blaces.InspectConn #TODO remove <<<
  end

end
