defmodule Blaces.BucketViewTest do
  use Blaces.ConnCase, async: true

  import Phoenix.View

  alias Blaces.Bucket

  @bucket %Bucket{:name => "Bucket A"}
  @buckets [%Bucket{:name => "Bucket B"}, %Bucket{:name => "Bucket C"}]

  test "renders index.json" do
    assert render(Blaces.BucketView, "index.json", %{buckets: @buckets}) ==
      %{data: [
        %{id: nil, is_public: false, name: "Bucket B", short_name: nil},
        %{id: nil, is_public: false, name: "Bucket C", short_name: nil}]}
  end

  test "renders bucket.json" do
    assert render(Blaces.BucketView, "bucket.json", %{bucket: @bucket}) ==
      %{id: nil, is_public: false, name: "Bucket A", short_name: nil}
  end
end
