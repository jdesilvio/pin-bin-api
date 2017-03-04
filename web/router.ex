defmodule Blaces.Router do
  use Blaces.Web, :router

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

  scope "/", Blaces do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/yelp", YelpController, :index
    post "/yelp", YelpController, :index
  end

  scope "/api/v1", Blaces do
    pipe_through :api

    get "/yelp", YelpController, :index
    post "/yelp", YelpController, :index
  end
end
