defmodule Blaces.PinController do
  use Blaces.Web, :controller

  alias Blaces.Pin

  def index(conn, _params) do
    pins = Repo.all(Pin)
    render(conn, :index, pins: pins)
  end

  def new(conn, _params) do
    changeset = Pin.changeset(%Pin{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"pin" => pin_params}, current_user) do
    changeset = Pin.changeset(%Pin{}, pin_params)

    case Repo.insert(changeset) do
      {:ok, pin} ->
        conn
        |> put_flash(:info, "Pin created successfully.")
        |> redirect(to: user_bucket_pin_path(conn, :index, current_user, pin))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pin = Repo.get!(Pin, id)
    render(conn, :show, pin: pin)
  end

  def edit(conn, %{"id" => id}) do
    pin = Repo.get!(Pin, id)
    changeset = Pin.changeset(pin)
    render(conn, :edit, pin: pin, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pin" => pin_params}, current_user) do
    pin = Repo.get!(Pin, id)
    changeset = Pin.changeset(pin, pin_params)

    case Repo.update(changeset) do
      {:ok, pin} ->
        conn
        |> put_flash(:info, "Pin updated successfully.")
        |> redirect(to: user_bucket_pin_path(conn, :show, current_user, pin))
      {:error, changeset} ->
        render(conn, :edit, pin: pin, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    pin = Repo.get!(Pin, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(pin)

    conn
    |> put_flash(:info, "Pin deleted successfully.")
    |> redirect(to: user_bucket_pin_path(conn, current_user, :index, pin))
  end
end
