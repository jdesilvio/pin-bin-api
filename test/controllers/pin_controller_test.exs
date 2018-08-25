defmodule PinBinWeb.PinControllerTest do
  use PinBinWeb.ConnCase

  alias PinBin.Pin
  alias PinBin.Factory

  @valid_attrs %{latitude: "120.5", longitude: "120.5", name: "some pin"}
  @invalid_attrs %{latitude: nil, longitude: nil, name: nil}

  describe "index/3" do
    test "lists pins" do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)
      pin = Factory.insert(:pin, user: user, bin: bin)

      conn =
        session_conn(user)
        |> get(user_bin_pin_path(conn, :index, user, bin))

      html = html_response(conn, 200)
      assert html =~ pin.name
    end

    test "list only pins associated with bin" do
      user = Factory.insert(:user)
      bin1 = Factory.insert(:bin, user: user)
      bin2 = Factory.insert(:bin, user: user)
      pin1 = Factory.insert(:pin, user: user, bin: bin1)
      pin2 = Factory.insert(:pin, user: user, bin: bin1)
      pin3 = Factory.insert(:pin, user: user, bin: bin2)
      pin4 = Factory.insert(:pin, user: user, bin: bin2)

      conn =
        session_conn(user)
        |> get(user_bin_pin_path(conn, :index, user, bin1))

      html = html_response(conn, 200)
      assert html =~ pin1.name
      assert html =~ pin2.name
      refute html =~ pin3.name
      refute html =~ pin4.name
    end
  end

  describe "new/3" do
    test "new pin" do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)

      conn =
        session_conn(user)
        |> get(user_bin_pin_path(conn, :new, user, bin))

      html = html_response(conn, 200)
      assert html =~ "New pin"
    end
  end

  describe "create/3" do
    test "new pin is created" do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)

      conn =
        session_conn(user)
        |> post(user_bin_pin_path(conn, :create, user, bin, pin: @valid_attrs))

      assert get_flash(conn)["info"] == "Pin created successfully."

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      html = html_response(conn, 200)
      assert html =~ @valid_attrs.name
    end

    #    test "new pin is not created with invalid attributes" do
    #      user = Factory.insert(:user)
    #      bin = Factory.insert(:bin, user: user)
    #
    #      conn =
    #        session_conn(user)
    #        |> post(user_bin_pin_path(conn, :create, user, bin, pin: @invalid_attrs))
    #
    #      assert get_flash(conn)["info"] == "Pin created successfully."
    #
    #      redir_path = redirected_to(conn)
    #      conn = get(recycle(conn), redir_path)
    #
    #      html = html_response(conn, 200)
    #      assert html =~ @valid_attrs.name
    #    end

  end

  describe "show/3" do
    test "show pin" do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)
      pin = Factory.insert(:pin, user: user, bin: bin)

      conn =
        session_conn(user)
        |> get(user_bin_pin_path(conn, :show, user, bin, pin))

      html = html_response(conn, 200)
      assert html =~ pin.name
    end

  end

  describe "edit/3" do
    test "edit pin" do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)
      pin = Factory.insert(:pin, user: user, bin: bin)

      conn =
        session_conn(user)
        |> get(user_bin_pin_path(conn, :edit, user, bin, pin))

      html = html_response(conn, 200)
      assert html =~ "Edit pin"
    end
  end

  describe "update/3" do
    test "update pin" do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)
      pin = Factory.insert(:pin, user: user, bin: bin)
      new_params = %{"name" => "new name", "longitude" => 99}

      conn =
        session_conn(user)
        |> patch(user_bin_pin_path(conn, :update, user, bin.id, pin.id, pin: new_params))

      assert get_flash(conn)["info"] == "Pin updated successfully."

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      html = html_response(conn, 200)
      assert html =~ "new name"
      refute html =~ pin.name
    end
  end

  describe "delete/3" do
    test "delete pin" do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)
      pin = Factory.insert(:pin, user: user, bin: bin)

      conn =
        session_conn(user)
        |> delete(user_bin_pin_path(conn, :delete, user, bin, pin))

      assert get_flash(conn)["info"] == "Pin deleted successfully."

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      html = html_response(conn, 200)
      refute html =~ pin.name
    end
  end
end
