defmodule Blaces.PinController do
  use Blaces.Web, :controller

  alias Blaces.Pin

  def index(conn, _params) do
    pins = Repo.all(Pin)
    render(conn, "index.html", pins: pins)
  end

  def new(conn, _params) do
    changeset = Pin.changeset(%Pin{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"pin" => pin_params}) do
    changeset = Pin.changeset(%Pin{}, pin_params)

    case Repo.insert(changeset) do
      {:ok, _pin} ->
        conn
        |> put_flash(:info, "Pin created successfully.")
        |> redirect(to: pin_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pin = Repo.get!(Pin, id)
    render(conn, "show.html", pin: pin)
  end

  def edit(conn, %{"id" => id}) do
    pin = Repo.get!(Pin, id)
    changeset = Pin.changeset(pin)
    render(conn, "edit.html", pin: pin, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pin" => pin_params}) do
    pin = Repo.get!(Pin, id)
    changeset = Pin.changeset(pin, pin_params)

    case Repo.update(changeset) do
      {:ok, pin} ->
        conn
        |> put_flash(:info, "Pin updated successfully.")
        |> redirect(to: pin_path(conn, :show, pin))
      {:error, changeset} ->
        render(conn, "edit.html", pin: pin, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pin = Repo.get!(Pin, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(pin)

    conn
    |> put_flash(:info, "Pin deleted successfully.")
    |> redirect(to: pin_path(conn, :index))
  end
end
