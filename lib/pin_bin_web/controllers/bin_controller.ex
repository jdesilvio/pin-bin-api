defmodule PinBinWeb.BinController do
  use PinBinWeb, :controller

  alias PinBin.Bin
  alias PinBin.User

  plug :scrub_params, "bin" when action in [:create, :update]

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

  def new(conn, _params, current_user) do
    changeset = Bin.changeset(%Bin{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"bin" => bin_params}, current_user) do
    derived_bin_params = bin_params |> derive_params

    changeset =
      current_user
      |> build_assoc(:bins)
      |> Bin.changeset(derived_bin_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Bin was created successfully!")
        |> redirect(to: user_bin_path(conn, :index, current_user))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    bin =
      Bin
      |> Repo.get!(id)
      |> Repo.preload(:user)

    render(conn, :show, bin: bin, user: current_user)
  end

  def edit(conn, %{"id" => id}, current_user) do
    bin = Bin |> Repo.get!(id)

    changeset = Bin.changeset(bin)

    render(conn, :edit, bin: bin, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bin" => bin_params}, current_user) do
    bin = Bin |> Repo.get!(id)
    derived_bin_params = bin_params |> derive_params
    changeset = Bin.changeset(bin, derived_bin_params)

    case Repo.update(changeset) do
      {:ok, bin} ->
        conn
        |> put_flash(:info, "Bin was updated successfully!")
        |> redirect(to: user_bin_path(conn, :show, current_user, bin))
      {:error, changeset} ->
        render(conn, :edit, bin: bin, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    Bin |> Repo.get!(id) |> Repo.delete!

    conn
    |> put_flash(:info, "Bin was deleted successfully!")
    |> redirect(to: user_bin_path(conn, :index, current_user))
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
