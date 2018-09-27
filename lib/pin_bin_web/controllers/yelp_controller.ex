defmodule PinBinWeb.YelpController do
  use PinBinWeb, :controller

  def index(conn, params) do
    render conn, "index.json", yelp: yelp_search!(params)
  end

  defp yelp_search!(params) do
    params = scrub_params(params)
    %{"latitude" => lat, "longitude" => long} = params
    cond do
      lat == nil -> nil
      long == nil -> nil
      true -> [params: [longitude: long, latitude: lat]]
              |> YelpEx.Client.search!()
    end
  end

  def scrub_params(params) do
    {:ok, params} =
      Map.get_and_update(params, "latitude", &scrub_param/1)
    {:ok, params} =
      Map.get_and_update(params, "longitude", &scrub_param/1)
    params
  end

  def scrub_param(param) do
    scrubbed_param = case param do
      nil -> nil
      "" -> nil
      _ -> param
    end
    {:ok, scrubbed_param}
  end
end
