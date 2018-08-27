defmodule PinBinWeb.Router do
  use PinBinWeb, :router

  ## Browser routing

  scope "/", PinBinWeb do
    pipe_through [:browser, :with_session]

    get "/", PageController, :index
    get "/elm", ElmController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    # Authenticated user
    scope "/"  do
      pipe_through [:login_required]

      resources "/users", UserController, only: [:show], as: :user do
        resources "/bins", BinController, as: :bin do
          resources "/pins", PinController, as: :pin
        end
      end

      get "/yelp", YelpController, :index
      post "/yelp", YelpController, :index
    end
  end


  ## API routing

  scope "/api/v1", PinBinWeb do
    pipe_through [:api]

    post "/sign_up", RegistrationController, :sign_up

    post "/auth", AuthController, :show

    resources "/users", UserController, only: [:new, :create]


    get "/yelp", YelpController, :index
    post "/yelp", YelpController, :index

    # Authenticated user
    scope "/"  do
      pipe_through [:api_auth, :login_required]

      resources "/users", UserController, only: [:show, :index] do
        resources "/bins", BinController do
          resources "/pins", PinController
        end
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
    plug PinBinWeb.CurrentUser
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated,
         handler: PinBinWeb.GuardianErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_auth do
    plug PinBinWeb.InspectConn #TODO remove <<<
  end

end
