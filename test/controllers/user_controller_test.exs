defmodule BlacesWeb.UserControllerTest do
  use BlacesWeb.ConnCase

  import Phoenix.ConnTest
  alias Blaces.User
  alias Blaces.Repo

  @valid_attrs %{username: "Moe", email: "moe@stooges.com", password: "abc123"}
  @invalid_attrs %{username: nil, email: nil, password: nil}
  @invalid_attrs2 %{username: "Larry", email: "larry@stooges.com", password: nil}


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
      assert html =~ "My Buckets"

      current_user = conn.assigns.current_user

      assert conn.request_path == "/users/#{current_user.id}"

      user1 = Repo.get(User, current_user.id)
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
    test "show user" do
      conn =
        build_conn()
        |> post(user_path(build_conn(), :create, %{"user" => @valid_attrs}))

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)  # follow redirect
      current_user = conn.assigns.current_user

      conn =
        recycle(conn)
        |> get(user_path(build_conn(), :show, current_user.id))

      assert get_flash(conn)["info"] == nil
      assert conn.request_path == "/users/#{current_user.id}"
    end
  end
end
