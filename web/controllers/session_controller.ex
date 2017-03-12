defmodule Blaces.SessionController do
  use Blaces.Web, :controller

  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email,
                                    "password" => password}}) do
  end

  def delete(conn, _) do
  end

end
