defmodule Blaces.SessionControllerTest do
  use Blaces.ConnCase

  alias Blaces.Factory

  describe "new/2" do
    test 'new session' do
      conn =
        build_conn()
        |> get(:new)

      assert conn.request_path == "/"
      assert html_response(conn, 200) =~ "Welcome to Blaces!"
      assert html_response(conn, 200) =~ "Register"
      assert html_response(conn, 200) =~ "Sign in"
    end
  end

  describe "create/2" do
    test 'create session' do
      user = Factory.insert(:user)

      session_creds = %{"email" => user.email, "password" => user.password}

      conn =
        build_conn()
        |> post(session_path(build_conn(), :create, %{"session" => session_creds}))

      assert get_flash(conn)["info"] == "You’re now signed in!"

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)  # follow redirect

      assert html_response(conn, 200) =~ "Sign out"
    end
  end

  describe "delete/2" do
    test 'delete session' do
      user = Factory.insert(:user)

      session_creds = %{"email" => user.email, "password" => user.password}

      conn =
        build_conn()
        |> post(session_path(build_conn(), :create, %{"session" => session_creds}))

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      conn =
        recycle(conn)
        |> delete(session_path(conn, :delete, user))

      assert get_flash(conn)["info"] == "See you later!"

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      assert html_response(conn, 200) =~ "Sign in"
    end
  end

end
