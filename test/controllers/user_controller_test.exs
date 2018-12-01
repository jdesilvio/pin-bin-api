defmodule PinBinWeb.UserControllerTest do
  use PinBinWeb.ConnCase

  import Phoenix.ConnTest
  alias PinBin.Factory

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer " <> jwt)
    {:ok, %{conn: conn, user: user, jwt: jwt}}
  end

  describe "index/2" do
    test "user index", %{conn: conn, user: user} do
      path = user_path(conn, :index)
      response =
        conn
        |> get(path)
        |> json_response(200)

      assert response == %{
        "data" => [
          %{
            "email" => user.email,
            "id" => user.id,
            "username" => user.username
          }
        ]
      }
    end
  end

  describe "show/2" do
    test "show user", %{conn: conn, user: user} do
      path = user_path(conn, :show, user.id)
      response =
        conn
        |> get(path)
        |> json_response(200)

      assert response == %{
        "data" => %{
          "email" => user.email,
          "id" => user.id,
          "username" => user.username
        }
      }
    end
  end
end
