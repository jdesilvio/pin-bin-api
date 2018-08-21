defmodule PinBinWeb.PinController do
  use PinBinWeb, :controller

  alias PinBin.Pin
  alias PinBin.Bucket

  plug :scrub_params, "pin" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params, current_user) do
    %{"bucket_id" => bucket_id} = params

    bucket = Bucket |> Repo.get!(bucket_id)

    pins =
      assoc(bucket, :pins)
      |> Repo.all
      |> Repo.preload(:user)
      |> Repo.preload(:bucket)

    render(conn, :index, pins: pins, bucket: bucket, user: current_user)
  end

  def new(conn, params, _current_user) do
    %{"bucket_id" => bucket_id} = params

    bucket = Bucket |> Repo.get!(bucket_id)

    changeset = Pin.changeset(%Pin{})

    render(conn, :new, changeset: changeset, bucket: bucket)
  end

  def create(conn, params, current_user) do
    %{"pin" => pin, "bucket_id" => bucket_id} = params

    bucket = Bucket |> Repo.get!(bucket_id)

    changeset =
      current_user
      |> build_assoc(:pins, bucket: bucket, bucket_id: bucket.id)
      |> Pin.changeset(pin)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Pin created successfully.")
        |> redirect(to: user_bucket_pin_path(conn, :index, current_user, bucket))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, params, current_user) do
    %{"id" => id, "bucket_id" => bucket_id} = params

    bucket = Bucket |> Repo.get!(bucket_id)
    pin = Pin |> Repo.get!(id)

    render(conn, :show, pin: pin, bucket: bucket, user: current_user)
  end

  def edit(conn, params, current_user) do
    %{"id" => id, "bucket_id" => bucket_id} = params

    bucket = Bucket |> Repo.get!(bucket_id)
    pin = Pin |> Repo.get!(id)

    changeset = Pin.changeset(pin)

    render(conn, :edit, pin: pin, bucket: bucket, user: current_user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pin" => pin_params}, current_user) do
    pin = Pin |> Repo.get!(id)
    bucket = Bucket |> Repo.get!(pin.bucket_id)

    changeset = Pin.changeset(pin, pin_params)

    case Repo.update(changeset) do
      {:ok, pin} ->
        conn
        |> put_flash(:info, "Pin updated successfully.")
        |> redirect(to: user_bucket_pin_path(conn, :show, current_user, bucket, pin))
      {:error, changeset} ->
        render(conn, :edit, pin: pin, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    pin = Pin |> Repo.get!(id)
    bucket = Bucket |> Repo.get!(pin.bucket_id)

    Repo.delete!(pin)

    conn
    |> put_flash(:info, "Pin deleted successfully.")
    |> redirect(to: user_bucket_pin_path(conn, :index, current_user, bucket))
  end
end
