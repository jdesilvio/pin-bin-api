defmodule Blaces.YelpController do
  use Blaces.Web, :controller

  def index(conn, _params) do
    unless _params["search"] == nil do
      %{"latitude" => lat, "longitude" => long} = _params["search"]
      options = [params: [longitude: long, latitude: lat]]
      IO.inspect YelpEx.Client.search(options)
    end

    render conn, "index.html"
  end

  def new(conn, _params) do
    :ok
  end
end
