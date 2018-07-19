defmodule Blaces.PinView do
  use Blaces.Web, :view

  def render("index.json", %{pins: pins}) do
    %{data: render_many(pins, Blaces.PinView, "pin.json")}
  end

  def render("pin.json", %{pin: pin}) do
    %{id: pin.id,
      name: pin.name,
      latitude: pin.lattitude,
      longitude: pin.longitude}
  end

end
