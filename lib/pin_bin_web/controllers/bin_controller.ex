defmodule PinBinWeb.BinController do
  use PinBinWeb, :controller

  alias PinBin.Bin
  alias PinBin.User

  plug PinBinWeb.AssignCurrentUser

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, current_user) do
    bins =
      User
      |> Repo.get!(current_user.id)
      |> assoc(:bins)
      |> Repo.all
      |> Repo.preload(:user)

    render(conn, :index, bins: bins, user: current_user)
  end

  def create(conn, %{"bin" => bin}, current_user) do
    bin = bin |> derive_params

    changeset =
      current_user
      |> build_assoc(:bins)
      |> Bin.changeset(bin)

    case Repo.insert(changeset) do
      {:ok, bin} ->
        resource = user_bin_path(conn, :show, current_user.id, bin.id)

        conn
        |> put_status(:created)
        |> put_resp_header("resource", resource)
        |> render(:show, user: current_user, bin: bin)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PinBinWeb.ErrorView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    bin =
      Bin
      |> Repo.get!(id)
      |> Repo.preload(:user)

    render(conn, :show, bin: bin, user: current_user)
  end

  def update(conn, %{"bin" => params, "id" => id}, current_user) do
    bin = Bin |> Repo.get!(id)
    derived_params = params |> derive_params

    changeset = Bin.changeset(bin, derived_params)

    case Repo.update(changeset) do
      {:ok, bin} ->
        resource = user_bin_path(conn, :show, current_user.id, bin.id)

        conn
        |> put_resp_header("resource", resource)
        |> render(:show, user: current_user, bin: bin)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(PinBinWeb.ErrorView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    Bin |> Repo.get!(id) |> Repo.delete!
    send_resp(conn, :no_content, "")
  end

  defp derive_params(params) do
    short_name = case params["name"] do
      nil -> params
      _ -> params["name"]
           |> String.downcase
           |> String.trim
           |> String.replace(" ", "_")
    end

    Map.put(params, "short_name", short_name)
  end
end
