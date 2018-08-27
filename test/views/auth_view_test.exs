defmodule PinBinWeb.AuthViewTest do
  use PinBinWeb.ConnCase

  import Phoenix.View
  import Poison

  @auth %{
    jwt: "ABC123!@#",
    exp: 15000000,
    token_type: "Bearer",
    resource: '/user/1'
  }

  test "render login.json" do
    json = render_to_string(PinBinWeb.AuthView, "login.json", @auth)
    assert json == encode!(@auth)
  end
end
