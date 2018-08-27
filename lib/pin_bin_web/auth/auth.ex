defmodule PinBinWeb.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias PinBin.User
  alias PinBin.Accounts

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

  def api_login(conn, user) do
    conn
    |> Guardian.Plug.api_sign_in(user)
  end

  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

  def login_by_email_and_pass(conn, email, password) do
    user = Accounts.get_user_by_email(email)
    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw
        {:error, :not_found, conn}
    end
  end

  def api_login_by_email_and_pass(conn, email, password) do
    user = Accounts.get_user_by_email(email)
    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, api_login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw
        {:error, :not_found, conn}
    end
  end
end
