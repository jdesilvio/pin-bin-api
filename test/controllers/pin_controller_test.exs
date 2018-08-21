defmodule PinBinWeb.PinControllerTest do
  use PinBinWeb.ConnCase

  alias PinBin.Pin
  alias PinBin.Factory

  @valid_attrs %{latitude: "120.5", longitude: "120.5", name: "some pin"}
  @invalid_attrs %{latitude: nil, longitude: nil, name: nil}

  describe "index/3" do
    test "lists pins" do
      user = Factory.insert(:user)
      bucket = Factory.insert(:bucket, user: user)
      pin = Factory.insert(:pin, user: user, bucket: bucket)

      conn =
        session_conn(user)
        |> get(user_bucket_pin_path(conn, :index, user, bucket))

      html = html_response(conn, 200)
      assert html =~ pin.name
    end

    test "list only pins associated with bucket" do
      user = Factory.insert(:user)
      bucket1 = Factory.insert(:bucket, user: user)
      bucket2 = Factory.insert(:bucket, user: user)
      pin1 = Factory.insert(:pin, user: user, bucket: bucket1)
      pin2 = Factory.insert(:pin, user: user, bucket: bucket1)
      pin3 = Factory.insert(:pin, user: user, bucket: bucket2)
      pin4 = Factory.insert(:pin, user: user, bucket: bucket2)

      conn =
        session_conn(user)
        |> get(user_bucket_pin_path(conn, :index, user, bucket1))

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
      bucket = Factory.insert(:bucket, user: user)

      conn =
        session_conn(user)
        |> get(user_bucket_pin_path(conn, :new, user, bucket))

      html = html_response(conn, 200)
      assert html =~ "New pin"
    end
  end

  describe "create/3" do
    test "new pin is created" do
      user = Factory.insert(:user)
      bucket = Factory.insert(:bucket, user: user)

      conn =
        session_conn(user)
        |> post(user_bucket_pin_path(conn, :create, user, bucket, pin: @valid_attrs))

      assert get_flash(conn)["info"] == "Pin created successfully."

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      html = html_response(conn, 200)
      assert html =~ @valid_attrs.name
    end

    #    test "new pin is not created with invalid attributes" do
    #      user = Factory.insert(:user)
    #      bucket = Factory.insert(:bucket, user: user)
    #
    #      conn =
    #        session_conn(user)
    #        |> post(user_bucket_pin_path(conn, :create, user, bucket, pin: @invalid_attrs))
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
      bucket = Factory.insert(:bucket, user: user)
      pin = Factory.insert(:pin, user: user, bucket: bucket)

      conn =
        session_conn(user)
        |> get(user_bucket_pin_path(conn, :show, user, bucket, pin))

      html = html_response(conn, 200)
      assert html =~ pin.name
    end

  end

  describe "edit/3" do
    test "edit pin" do
      user = Factory.insert(:user)
      bucket = Factory.insert(:bucket, user: user)
      pin = Factory.insert(:pin, user: user, bucket: bucket)

      conn =
        session_conn(user)
        |> get(user_bucket_pin_path(conn, :edit, user, bucket, pin))

      html = html_response(conn, 200)
      assert html =~ "Edit pin"
    end
  end

  describe "update/3" do
    test "update pin" do
      user = Factory.insert(:user)
      bucket = Factory.insert(:bucket, user: user)
      pin = Factory.insert(:pin, user: user, bucket: bucket)
      new_params = %{"name" => "new name", "longitude" => 99}

      conn =
        session_conn(user)
        |> patch(user_bucket_pin_path(conn, :update, user, bucket.id, pin.id, pin: new_params))

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
      bucket = Factory.insert(:bucket, user: user)
      pin = Factory.insert(:pin, user: user, bucket: bucket)

      conn =
        session_conn(user)
        |> delete(user_bucket_pin_path(conn, :delete, user, bucket, pin))

      assert get_flash(conn)["info"] == "Pin deleted successfully."

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      html = html_response(conn, 200)
      refute html =~ pin.name
    end
  end
end
