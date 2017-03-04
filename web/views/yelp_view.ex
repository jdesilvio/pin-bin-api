defmodule Blaces.YelpView do
  use Blaces.Web, :view

  def render("index.json", %{yelp: yelp}) do
    #yelp
    %{bta: "hello", data: render_one(yelp, Blaces.YelpView, "yelp.json")}
  end

  def render("yelp.json", %{yelp: yelp}) do
    %{yelp: yelp}
  end
end
