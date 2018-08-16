defmodule BlacesWeb.AuthViewTest do
  use BlacesWeb.ConnCase

  import Phoenix.View

  @auth %{jwt: "ABC123!@#", exp: 15000000, token_type: "Bearer"}

  test "render login.json" do
    assert render_to_string(BlacesWeb.AuthView,
                            "login.json",
                            @auth) ==
      "{\"token_type\":\"Bearer\",\"jwt\":\"ABC123!@#\",\"exp\":15000000}"
  end
end
