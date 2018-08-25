defmodule PinBinWeb.BinControllerTest do
  use PinBinWeb.ConnCase

  import Phoenix.ConnTest
  alias PinBin.User
  alias PinBin.Bin
  alias PinBin.Repo
  alias PinBin.Factory

  @valid_attrs %{"name" => "my bin"}

  describe "index/3" do
    test "list bins" do
      user = Factory.insert(:user)
      bin1 = Factory.insert(:bin, user: user)
      bin2 = Factory.insert(:bin, user: user)

      conn =
        session_conn(user)
        |> get(user_bin_path(conn, :index, user))

      html = html_response(conn, 200)
      assert html =~ bin1.name
      assert html =~ bin2.name
    end

    test "only lists current user's bins" do
      user1 = Factory.insert(:user)
      user2 = Factory.insert(:user)
      bin1 = Factory.insert(:bin, user: user1)
      bin2 = Factory.insert(:bin, user: user2)

      conn =
        session_conn(user1)
        |> get(user_bin_path(conn, :index, user1))

      html = html_response(conn, 200)
      assert html =~ bin1.name
      refute html =~ bin2.name
    end
  end

  describe "new/3" do
    test "new bin" do
      user = Factory.insert(:user)

      conn =
        session_conn(user)
        |> get(user_bin_path(conn, :new, user))

      html = html_response(conn, 200)
      assert html =~ "Create Bin"
    end
  end

  describe "create/3" do
    test "create bin" do
      user = Factory.insert(:user)

      conn =
        session_conn(user)
        |> post(user_bin_path(conn, :create, user, bin: @valid_attrs))

      assert get_flash(conn)["info"] == "Bin was created successfully!"

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      html = html_response(conn, 200)
      assert html =~ @valid_attrs["name"]
    end
  end

  describe "show/3" do
    test "show bin" do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)

      conn =
        session_conn(user)
        |> get(user_bin_path(conn, :show, user.id, bin.id))

      html = html_response(conn, 200)
      assert html =~ bin.name
    end
  end

  describe "edit/3" do
    test "edit bin" do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)

      conn =
        session_conn(user)
        |> get(user_bin_path(conn, :edit, user, bin))

      html = html_response(conn, 200)
      assert html =~ "Edit Bin"
      assert html =~ bin.name
    end
  end

  describe "update/3" do
    test "update bin" do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)
      new_params = %{"name" => "new name"}
      new_bin = %{bin | name: "new name"}
      IO.inspect new_bin

      conn =
        session_conn(user)
        |> patch(user_bin_path(conn, :update, user, bin.id, bin: new_params))

      assert get_flash(conn)["info"] == "Bin was updated successfully!"

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      html = html_response(conn, 200)
      assert html =~ "new name"
      refute html =~ bin.name
    end
  end

  describe "delete/3" do
    test "delete bin" do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)

      conn =
        session_conn(user)
        |> delete(user_bin_path(conn, :delete, user, bin))

      assert get_flash(conn)["info"] == "Bin was deleted successfully!"

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      html = html_response(conn, 200)
      refute html =~ bin.name
    end
  end
end
