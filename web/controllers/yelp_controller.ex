defmodule Blaces.YelpController do
  use Blaces.Web, :controller

  def index(conn, _params) do
    yelp =
      case Enum.find(conn.private[:phoenix_pipelines], fn(x) -> x == :api end) do
        :api -> Blaces.Search.yelp_search(_params)
        nil -> nil
      end

    unless _params["search"] == nil do
      %{"latitude" => lat, "longitude" => long} = _params["search"]
      options = [params: [longitude: long, latitude: lat]]
      IO.inspect YelpEx.Client.search(options)
    end

    IO.inspect yelp
    case yelp do
      nil -> render conn, "index.html"
      _ -> render conn, "index.json", yelp: yelp
    end

  end

end

defmodule Blaces.Search do

  def yelp_search(_params) do
    IO.puts "search"
    IO.inspect _params
    %{"latitude" => lat, "longitude" => long} = _params
    options = [params: [longitude: long, latitude: lat]]
    YelpEx.Client.search!(options)
  end

end
