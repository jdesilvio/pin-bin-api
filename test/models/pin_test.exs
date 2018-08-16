defmodule Blaces.PinTest do
  use Blaces.DataCase

  alias Blaces.Pin

  @valid_attrs %{latitude: "120.5", longitude: "120.5", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Pin.changeset(%Pin{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Pin.changeset(%Pin{}, @invalid_attrs)
    refute changeset.valid?
  end
end
