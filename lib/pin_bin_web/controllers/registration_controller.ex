defmodule PinBinWeb.RegistrationController do
  use PinBinWeb, :controller

  alias PinBin.User

  def sign_up(conn, params) do
    changeset = User.registration_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        resource = user_path(conn, :show, user)

        conn
        |> put_status(:created)
        |> put_resp_header("resource", resource)
        |> render("success.json", user: user, resource: resource)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PinBinWeb.ErrorView, "error.json", changeset: changeset)
    end
  end
end
