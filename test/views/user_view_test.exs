defmodule PinBinWeb.UserViewTest do
  use PinBinWeb.ConnCase, async: true

  import Phoenix.View

  alias PinBin.User

  @user %User{}

  test "renders show.json" do
    assert render(PinBinWeb.UserView, "show.json", %{user: @user}) ==
      %{data: %{email: nil, id: nil, username: nil}}
  end

  test "renders user.json" do
    assert render(PinBinWeb.UserView, "user.json", %{user: @user}) ==
      %{email: nil, id: nil, username: nil}
  end
end
