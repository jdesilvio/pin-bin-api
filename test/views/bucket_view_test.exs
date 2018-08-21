defmodule PinBinWeb.BucketViewTest do
  use PinBinWeb.ConnCase, async: true

  import Phoenix.View

  alias PinBin.Bucket

  @bucket %Bucket{:name => "Bucket A"}
  @buckets [%Bucket{:name => "Bucket B"}, %Bucket{:name => "Bucket C"}]

  test "renders index.json" do
    assert render(PinBinWeb.BucketView, "index.json", %{buckets: @buckets}) ==
      %{data: [
        %{id: nil, is_public: false, name: "Bucket B", short_name: nil},
        %{id: nil, is_public: false, name: "Bucket C", short_name: nil}]}
  end

  test "renders bucket.json" do
    assert render(PinBinWeb.BucketView, "bucket.json", %{bucket: @bucket}) ==
      %{id: nil, is_public: false, name: "Bucket A", short_name: nil}
  end
end
