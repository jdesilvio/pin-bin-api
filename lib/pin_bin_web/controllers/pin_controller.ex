defmodule PinBinWeb.PinController do
  use PinBinWeb, :controller

  alias PinBin.Pin
  alias PinBin.Bin

  plug :scrub_params, "pin" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"bin_id" => bin_id}, current_user) do
    bin = Bin |> Repo.get!(bin_id)
    pins =
      bin
      |> assoc(:pins)
      |> Repo.all
      |> Repo.preload(:user)
      |> Repo.preload(:bin)

    render(conn, :index, pins: pins, bin: bin, user: current_user)
  end

  def new(conn, %{"bin_id" => bin_id}, _current_user) do
    bin = Bin |> Repo.get!(bin_id)
    changeset = Pin.changeset(%Pin{})
    render(conn, :new, changeset: changeset, bin: bin)
  end

  def create(conn, %{"pin" => pin, "bin_id" => bin_id}, current_user) do
    bin = Bin |> Repo.get!(bin_id)

    changeset =
      current_user
      |> build_assoc(:pins, bin: bin, bin_id: bin.id)
      |> Pin.changeset(pin)

    case Repo.insert(changeset) do
      {:ok, pin} ->
        resource = user_bin_pin_path(conn, :show, current_user.id, bin.id, pin.id)

        conn
        |> put_status(:created)
        |> put_resp_header("resource", resource)
        |> render(:show, user: current_user, bin: bin, pin: pin)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "bin_id" => bin_id}, current_user) do
    bin = Bin |> Repo.get!(bin_id)
    pin = Pin |> Repo.get!(id)
    render(conn, :show, pin: pin, bin: bin, user: current_user)
  end

  def update(conn, %{"id" => id, "pin" => pin_params}, current_user) do
    pin = Pin |> Repo.get!(id)
    bin = Bin |> Repo.get!(pin.bin_id)

    changeset = Pin.changeset(pin, pin_params)

    case Repo.update(changeset) do
      {:ok, pin} ->
        resource = user_bin_pin_path(conn, :show, current_user.id, bin.id, pin.id)

        conn
        |> put_resp_header("resource", resource)
        |> render(:show, user: current_user, bin: bin, pin: pin)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    pin = Pin |> Repo.get!(id)
    bin = Bin |> Repo.get!(pin.bin_id)
    Repo.delete!(pin)
    send_resp(conn, :no_content, "")
  end
end
