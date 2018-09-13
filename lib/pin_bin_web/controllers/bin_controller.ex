defmodule PinBinWeb.BinController do
  use PinBinWeb, :controller

  alias PinBin.Bin
  alias PinBin.User

  plug :scrub_params, "bin" when action in [:create, :update]
  plug PinBinWeb.AssignCurrentUser

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id}, _current_user) do
    user = User |> Repo.get!(user_id)

    bins =
      user
      |> assoc(:bins)
      |> Repo.all
      |> Repo.preload(:user)

    render(conn, :index, bins: bins, user: user)
  end

  def create(conn, %{"bin" => bin_params}, current_user) do
    derived_bin_params = bin_params |> derive_params

    changeset =
      current_user
      |> build_assoc(:bins)
      |> Bin.changeset(derived_bin_params)

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
        |> render(:error, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    bin =
      Bin
      |> Repo.get!(id)
      |> Repo.preload(:user)

    render(conn, :show, bin: bin, user: current_user)
  end

  def update(conn, %{"id" => id, "bin" => bin_params}, current_user) do
    bin = Bin |> Repo.get!(id)
    derived_bin_params = bin_params |> derive_params
    changeset = Bin.changeset(bin, derived_bin_params)

    case Repo.update(changeset) do
      {:ok, bin} ->
        resource = user_bin_path(conn, :show, current_user.id, bin.id)

        conn
        |> put_resp_header("resource", resource)
        |> render(:show, user: current_user, bin: bin)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    Bin |> Repo.get!(id) |> Repo.delete!
    send_resp(conn, :no_content, "")
  end

  defp derive_params(bin_params) do
    short_name = case bin_params["name"] do
      nil -> bin_params
      _ -> bin_params["name"]
           |> String.downcase
           |> String.trim
           |> String.replace(" ", "_")
    end

    Map.put(bin_params, "short_name", short_name)
  end
end
