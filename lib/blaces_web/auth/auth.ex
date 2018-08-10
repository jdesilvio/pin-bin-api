defmodule BlacesWeb.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias BlacesWeb.User
  alias BlacesWeb.Repo

  def login_by_email_and_pass(conn, email, given_pass) do
    user = Repo.get_by(User, email: email)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw
        {:error, :not_found, conn}
    end
  end

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end

  def api_login_by_email_and_pass(conn, params) do
    %{:user => user, :password => given_pass} =
      user_and_password_from_params(params)

    if user && given_pass do
      cond do
        user && checkpw(given_pass, user.password_hash) ->
          {:ok, api_login(conn, user)}
        user ->
          {:error, :unauthorized, conn}
        true ->
          dummy_checkpw
          {:error, :not_found, conn}
      end
    else
      {:error, :validation_error, conn}
    end
  end

  def api_login(conn, user) do
    conn
    |> Guardian.Plug.api_sign_in(user)
  end

  defp user_and_password_from_params(params) do
    email = Map.get(params, "email")
    user = case email do
      nil -> nil
      _ -> Repo.get_by(User, email: email)
    end
    password = Map.get(params, "password")

    %{:user => user, :password => password}
  end
end
