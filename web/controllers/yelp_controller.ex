defmodule Blaces.YelpController do
  use Blaces.Web, :controller

  def index(conn, params) do
    IO.inspect params
    case conn.request_path do
      "/yelp" -> conn
                 |> assign(:yelp, yelp_search!(params["search"]))
                 |> render "index.html"
      "/api/v1/yelp" ->
        render conn, "index.json", yelp: yelp_search!(params)
    end
  end

  defp yelp_search!(params) do
    if params["latitude"] == nil or params["longitude"] == nil do
      nil
    else
      %{"latitude" => lat, "longitude" => long} = params
      options = [params: [longitude: long, latitude: lat]]
      YelpEx.Client.search!(options)
    end
  end

end
