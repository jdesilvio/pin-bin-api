defmodule PinBinWeb.PinView do
  use PinBinWeb, :view

  def render("index.json", %{pins: pins}) do
    %{data: render_many(pins, PinBinWeb.PinView, "pin.json")}
  end

  def render("show.json", %{pin: pin}) do
    %{data: render_one(pin, PinBinWeb.PinView, "pin.json")}
  end

  def render("pin.json", %{pin: pin}) do
    %{id: pin.id,
      name: pin.name,
      latitude: pin.latitude,
      longitude: pin.longitude}
  end

end
