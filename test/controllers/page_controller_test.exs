defmodule PinBinWeb.PageControllerTest do
  use PinBinWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to PinBin!"
  end
end
