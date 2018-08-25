defmodule PinBinWeb.BinView do
  use PinBinWeb, :view

  def render("index.json", %{bins: bins}) do
    %{data: render_many(bins, PinBinWeb.BinView, "bin.json")}
  end

  def render("bin.json", %{bin: bin}) do
    %{id: bin.id,
      name: bin.name,
      short_name: bin.short_name,
      is_public: bin.is_public}
  end

end
