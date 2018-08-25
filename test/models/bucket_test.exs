defmodule PinBin.BinTest do
  use PinBin.DataCase

  alias PinBin.Bin

  @valid_attrs %{is_public: true, name: "some content", short_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bin.changeset(%Bin{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Bin.changeset(%Bin{}, @invalid_attrs)
    refute changeset.valid?
  end
end
