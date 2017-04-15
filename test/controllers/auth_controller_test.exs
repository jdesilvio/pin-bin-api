defmodule Blaces.AuthControllerTest do
  use Blaces.ConnCase

  import Blaces.Factory

  alias Blaces.Repo
  alias Blaces.User

  setup do
    user = user_factory()
    {:ok, jwt, full_claims} = Guardian.encode_and_sign(user)
    {:ok, %{user: user, jwt: jwt, claims: full_claims}}
  end

  test "GET /api/v1/auth", %{jwt: jwt} do
    conn = build_conn()
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get("/api/v1/auth")

    assert conn == ""
  end
end
