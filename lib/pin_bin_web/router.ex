defmodule PinBinWeb.Router do
  use PinBinWeb, :router

  scope "/api/v1", PinBinWeb do
    pipe_through [:api]

    post "/sign_up", RegistrationController, :sign_up
    post "/auth", AuthController, :show

    # Authenticated user
    scope "/"  do
      pipe_through [:api_auth, :login_required]

      resources "/users", UserController, only: [:show, :index] do
        resources "/bins", BinController, except: [:new, :edit] do
          resources "/pins", PinController, except: [:new, :edit]
        end
      end

      get "/yelp", YelpController, :index
      post "/yelp", YelpController, :index
    end
  end

  ## Pipelines

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated,
         handler: PinBinWeb.GuardianErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  end

end
