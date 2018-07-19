defmodule Blaces.SessionController do
  use Blaces.Web, :controller

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    render(conn, :new)
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Blaces.Auth.login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You’re now signed in!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render(:new)
    end
  end

  def delete(conn, _) do
    conn
    |> Blaces.Auth.logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: page_path(conn, :index))
  end
end
