defmodule PinBinWeb.BinViewTest do
  use PinBinWeb.ConnCase, async: true

  import Phoenix.View

  alias PinBin.Bin

  @bin %Bin{:name => "Bin A"}
  @bins [%Bin{:name => "Bin B"}, %Bin{:name => "Bin C"}]

  test "renders index.json" do
    assert render(PinBinWeb.BinView, "index.json", %{bins: @bins}) ==
      %{data: [
        %{id: nil, is_public: false, name: "Bin B", short_name: nil},
        %{id: nil, is_public: false, name: "Bin C", short_name: nil}]}
  end

  test "renders bin.json" do
    assert render(PinBinWeb.BinView, "bin.json", %{bin: @bin}) ==
      %{id: nil, is_public: false, name: "Bin A", short_name: nil}
  end
end
