defmodule PinBinWeb.AuthController do
  use PinBinWeb, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias PinBin.User
  alias PinBin.Accounts

  @token_type "Bearer"

  def show(conn, %{"email" => email, "password" => password}) do
    case PinBinWeb.Auth.api_login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        jwt = Guardian.Plug.current_token(conn)

        {:ok, claims} = Guardian.Plug.claims(conn)
        exp = Map.get(claims, "exp")

        user = Accounts.get_user_by_email(email)
        resource = user_path(conn, :show, user)

        conn
        |> put_resp_header("authorization", @token_type <> " #{jwt}")
        |> put_resp_header("x-expires", "#{exp}")
        |> put_resp_header("resource", resource)
        |> render(
             "login.json",
             jwt: jwt,
             exp: exp,
             token_type: @token_type,
             resource: resource
           )
      {:error, reason, conn} ->
        conn
        |> render(PinBinWeb.ErrorView, "error.json", reason: reason)
    end
  end
end
