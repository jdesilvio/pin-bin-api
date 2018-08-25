defmodule PinBinWeb.PinController do
  use PinBinWeb, :controller

  alias PinBin.Pin
  alias PinBin.Bin

  plug :scrub_params, "pin" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params, current_user) do
    %{"bin_id" => bin_id} = params

    bin = Bin |> Repo.get!(bin_id)

    pins =
      assoc(bin, :pins)
      |> Repo.all
      |> Repo.preload(:user)
      |> Repo.preload(:bin)

    render(conn, :index, pins: pins, bin: bin, user: current_user)
  end

  def new(conn, params, _current_user) do
    %{"bin_id" => bin_id} = params

    bin = Bin |> Repo.get!(bin_id)

    changeset = Pin.changeset(%Pin{})

    render(conn, :new, changeset: changeset, bin: bin)
  end

  def create(conn, params, current_user) do
    %{"pin" => pin, "bin_id" => bin_id} = params

    bin = Bin |> Repo.get!(bin_id)

    changeset =
      current_user
      |> build_assoc(:pins, bin: bin, bin_id: bin.id)
      |> Pin.changeset(pin)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Pin created successfully.")
        |> redirect(to: user_bin_pin_path(conn, :index, current_user, bin))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, params, current_user) do
    %{"id" => id, "bin_id" => bin_id} = params

    bin = Bin |> Repo.get!(bin_id)
    pin = Pin |> Repo.get!(id)

    render(conn, :show, pin: pin, bin: bin, user: current_user)
  end

  def edit(conn, params, current_user) do
    %{"id" => id, "bin_id" => bin_id} = params

    bin = Bin |> Repo.get!(bin_id)
    pin = Pin |> Repo.get!(id)

    changeset = Pin.changeset(pin)

    render(conn, :edit, pin: pin, bin: bin, user: current_user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pin" => pin_params}, current_user) do
    pin = Pin |> Repo.get!(id)
    bin = Bin |> Repo.get!(pin.bin_id)

    changeset = Pin.changeset(pin, pin_params)

    case Repo.update(changeset) do
      {:ok, pin} ->
        conn
        |> put_flash(:info, "Pin updated successfully.")
        |> redirect(to: user_bin_pin_path(conn, :show, current_user, bin, pin))
      {:error, changeset} ->
        render(conn, :edit, pin: pin, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    pin = Pin |> Repo.get!(id)
    bin = Bin |> Repo.get!(pin.bin_id)

    Repo.delete!(pin)

    conn
    |> put_flash(:info, "Pin deleted successfully.")
    |> redirect(to: user_bin_pin_path(conn, :index, current_user, bin))
  end
end
