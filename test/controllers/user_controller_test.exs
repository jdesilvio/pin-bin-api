defmodule PinBinWeb.UserControllerTest do
  use PinBinWeb.ConnCase

  import Phoenix.ConnTest
  alias PinBin.User
  alias PinBin.Factory
  alias PinBin.Accounts

  @valid_attrs %{username: "Moe", email: "moe@stooges.com", password: "abc123"}
  @invalid_attrs %{username: nil, email: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Auth.create_user(@valid_attrs)
    user
  end

  def fixture(:current_user) do
    {:ok, current_user} = Accounts.create_user(@valid_attrs)
    current_user
  end

  describe "new/2" do
    test "new user" do
      conn =
        build_conn()
        |> get(user_path(build_conn(), :new))

      assert conn.request_path == "/users/new"
      assert html_response(conn, 200) =~ "User Registration"
    end
  end

  describe "create/2" do
    test "create user" do
      conn =
        build_conn()
        |> post(user_path(build_conn(), :create, %{"user" => @valid_attrs}))

      redir_path = redirected_to(conn)
      assert redir_path =~ "/users/"

      conn = get(recycle(conn), redir_path)  # follow redirect

      assert get_flash(conn)["info"] == "#{@valid_attrs.username} created!"

      html = html_response(conn, 200)
      assert html =~ @valid_attrs.email
      assert html =~ "My Bins"

      current_user = conn.assigns.current_user

      assert conn.request_path == "/users/#{current_user.id}"

      user1 = Accounts.get_user(current_user.id)
      assert user1.username == @valid_attrs.username
      assert user1.email == @valid_attrs.email
    end

    test "create user error" do
      conn =
        build_conn()
        |> post(user_path(build_conn(), :create, %{"user" => @invalid_attrs}))

      html = html_response(conn, 200)
      assert html =~ "There are some errors"

      errors = conn.assigns.changeset.errors
      {email_error, _} = errors[:email]
      {username_error, _} = errors[:username]
      {password_error, _} = errors[:password]

      assert email_error == "can't be blank"
      assert username_error == "can't be blank"
      assert password_error == "can't be blank"
    end
  end

  describe "show/2" do
    setup [:setup_current_user]

    test "show user", %{conn: conn, current_user: current_user} do
      conn =
        recycle(conn)
        |> get(user_path(build_conn(), :show, current_user.id))

      assert get_flash(conn)["info"] == nil
      assert conn.request_path == "/users/#{current_user.id}"
    end
  end

  #  describe "index/2" do
  #    setup [:setup_current_user]
  #
  #    test "user index", %{conn: conn, current_user: current_user} do
  #
  #      conn =
  #        recycle(conn)
  #        |> get(user_path(build_conn(), :index))
  #        |> json_response(200)
  #
  #      IO.inspect conn
  #
  #      assert 1==0
  #    end
  #  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp setup_current_user(conn) do
    conn =
      build_conn()
      |> post(user_path(build_conn(), :create, %{"user" => @valid_attrs}))

    redir_path = redirected_to(conn)
    conn = get(recycle(conn), redir_path)
    current_user = conn.assigns.current_user

    {:ok, conn: conn, current_user: current_user}
  end
end
