defmodule PinBinWeb.Auth do
  @moduledoc"""
  API authentication.
  """
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias PinBin.Accounts

  def api_login(conn, user) do
    conn
    |> Guardian.Plug.api_sign_in(user)
  end

  def api_login_by_email_and_pass(conn, email, password) do
    user = Accounts.get_user_by_email(email)
    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, api_login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end
end
