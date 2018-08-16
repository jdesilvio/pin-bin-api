defmodule Blaces.BucketTest do
  use Blaces.DataCase

  alias Blaces.Bucket

  @valid_attrs %{is_public: true, name: "some content", short_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bucket.changeset(%Bucket{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Bucket.changeset(%Bucket{}, @invalid_attrs)
    refute changeset.valid?
  end
end
