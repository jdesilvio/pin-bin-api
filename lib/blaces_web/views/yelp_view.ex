defmodule BlacesWeb.YelpView do
  use Blaces.Web, :view

  def render("index.json", %{yelp: yelp}) do
    %{data: render_one(yelp, BlacesWeb.YelpView, "yelp.json")}
  end

  def render("yelp.json", %{yelp: yelp}) do
    %{yelp: yelp}
  end
end
