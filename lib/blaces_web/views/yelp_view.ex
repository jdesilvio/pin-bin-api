defmodule PinBinWeb.YelpView do
  use PinBinWeb, :view

  def render("index.json", %{yelp: yelp}) do
    %{data: render_one(yelp, PinBinWeb.YelpView, "yelp.json")}
  end

  def render("yelp.json", %{yelp: yelp}) do
    %{yelp: yelp}
  end
end
