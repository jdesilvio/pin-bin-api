defmodule PinBinWeb.YelpController do
  use PinBinWeb, :controller

  def index(conn, params) do
    case conn.request_path do
      "/yelp" ->
        conn
        |> assign(:yelp, yelp_search!(params["search"]))
        |> render(:index)
      "/api/v1/yelp" ->
        render conn, "index.json", yelp: yelp_search!(params)
    end
  end

  defp yelp_search!(params) do
    if scrub_param(params["latitude"]) == nil or scrub_param(params["longitude"]) == nil do
      nil
    else
      %{"latitude" => lat, "longitude" => long} = params
      options = [params: [longitude: long, latitude: lat]]
      YelpEx.Client.search!(options)
    end
  end

  defp scrub_param(param) do
    case param do
      nil -> nil
      "" -> nil
      _ -> param
    end
  end
end
