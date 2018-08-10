defmodule Blaces.AuthControllerTest do
  use Blaces.ConnCase

  alias Blaces.Factory
  alias Blaces.Repo
  alias Blaces.User

  setup do
    user = Factory.insert(:user)
    {:ok, jwt, full_claims} = Guardian.encode_and_sign(user)
    {:ok, %{user: user, jwt: jwt, claims: full_claims}}
  end

  test "show/2", %{user: user, conn: conn} do
    conn =
      conn
      |> post(auth_path(build_conn(), :show, email: user.email, password: user.password))

    resp = json_response(conn, 200)
    assert resp["exp"] > 0
    assert is_binary(resp["jwt"])
    assert resp["token_type"] == "Bearer"
  end
end
