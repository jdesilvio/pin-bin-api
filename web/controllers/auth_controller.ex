defmodule Blaces.AuthController do
  use Blaces.Web, :controller

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Blaces.User

  def login(conn, params) do
    %{"email" => email, "password" => given_pass} = params
    user = Repo.get_by(User, email: email)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        signin_user(conn, user)
      user ->
        {:error, :unauthorized, conn}  #TODO Implement for API
      true ->
        dummy_checkpw
        {:error, :not_found, conn}  # Implement for API
    end
  end

  #TODO move to Blaces.Auth
  defp signin_user(conn, user) do
    auth = conn
            |> Guardian.Plug.api_sign_in(user)
            |> Guardian.Plug.current_token
    #IO.inspect token
    render(conn, "login.json", auth: auth)
  end

end
