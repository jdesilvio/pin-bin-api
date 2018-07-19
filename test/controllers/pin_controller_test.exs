defmodule Blaces.PinControllerTest do
  use Blaces.ConnCase

  alias Blaces.Pin
  @valid_attrs %{latitude: "120.5", longitude: "120.5", name: "some content"}
  @invalid_attrs %{}

#  test "lists all entries on index", %{conn: conn} do
#    conn = get conn, pin_path(conn, :index)
#    assert html_response(conn, 200) =~ "Listing pins"
#  end
#
#  test "renders form for new resources", %{conn: conn} do
#    conn = get conn, pin_path(conn, :new)
#    assert html_response(conn, 200) =~ "New pin"
#  end
#
#  test "creates resource and redirects when data is valid", %{conn: conn} do
#    conn = post conn, pin_path(conn, :create), pin: @valid_attrs
#    assert redirected_to(conn) == pin_path(conn, :index)
#    assert Repo.get_by(Pin, @valid_attrs)
#  end
#
#  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
#    conn = post conn, pin_path(conn, :create), pin: @invalid_attrs
#    assert html_response(conn, 200) =~ "New pin"
#  end
#
#  test "shows chosen resource", %{conn: conn} do
#    pin = Repo.insert! %Pin{}
#    conn = get conn, pin_path(conn, :show, pin)
#    assert html_response(conn, 200) =~ "Show pin"
#  end
#
#  test "renders page not found when id is nonexistent", %{conn: conn} do
#    assert_error_sent 404, fn ->
#      get conn, pin_path(conn, :show, -1)
#    end
#  end
#
#  test "renders form for editing chosen resource", %{conn: conn} do
#    pin = Repo.insert! %Pin{}
#    conn = get conn, pin_path(conn, :edit, pin)
#    assert html_response(conn, 200) =~ "Edit pin"
#  end
#
#  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
#    pin = Repo.insert! %Pin{}
#    conn = put conn, pin_path(conn, :update, pin), pin: @valid_attrs
#    assert redirected_to(conn) == pin_path(conn, :show, pin)
#    assert Repo.get_by(Pin, @valid_attrs)
#  end
#
#  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
#    pin = Repo.insert! %Pin{}
#    conn = put conn, pin_path(conn, :update, pin), pin: @invalid_attrs
#    assert html_response(conn, 200) =~ "Edit pin"
#  end
#
#  test "deletes chosen resource", %{conn: conn} do
#    pin = Repo.insert! %Pin{}
#    conn = delete conn, pin_path(conn, :delete, pin)
#    assert redirected_to(conn) == pin_path(conn, :index)
#    refute Repo.get(Pin, pin.id)
#  end
end
