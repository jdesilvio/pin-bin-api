defmodule PinBinWeb.UserController do
  use PinBinWeb, :controller

  alias PinBin.User

  plug :scrub_params, "user" when action in [:create]

  def index(conn, _params) do
    users = User |> Repo.all()
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = User |> Repo.get!(id)
    render(conn, :show, user: user)
  end
end
