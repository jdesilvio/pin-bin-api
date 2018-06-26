defmodule Blaces.PinController do
  use Blaces.Web, :controller

  alias Blaces.Pin
  alias Blaces.Bucket
  alias Blaces.User

  plug :scrub_params, "pin" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, params, current_user) do
    %{"user_id" => user_id, "bucket_id" => bucket_id} = params

    user = User |> Repo.get!(user_id)
    bucket = Bucket |> Repo.get!(bucket_id)
    pins =
      assoc(user, :pins)
      |> Repo.all
      |> Repo.preload(:user)
      |> Repo.preload(:bucket)

    render(conn, :index, pins: pins, bucket: bucket, user: user)
  end

  def new(conn, params, current_user) do
    changeset =
      current_user
      |> build_assoc(:pins)
      |> Pin.changeset

    bucket_id = params["bucket_id"]
    bucket = Repo.get(Bucket, bucket_id)

    render(conn, :new, changeset: changeset, bucket: bucket)
  end

  def create(conn, %{"pin" => pin_params}, current_user) do
    # TODO add private function to build params
    pin_params = Map.put(pin_params, "bucket_id", conn.params["bucket_id"])
    pin_params = Map.put(pin_params, "user_id", conn.params["user_id"])

    bucket = Repo.get!(Bucket, conn.params["bucket_id"])

    changeset =
      current_user
      |> build_assoc(:pins, bucket: bucket, bucket_id: bucket.id)
      |> Pin.changeset(pin_params)

    case Repo.insert(changeset) do
      {:ok, pin} ->
        conn
        |> put_flash(:info, "Pin created successfully.")
        |> redirect(to: user_bucket_pin_path(conn, :index, current_user, conn.params["bucket_id"]))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, params, current_user) do
    %{"id" => id, "user_id" => user_id, "bucket_id" => bucket_id} = params
    pin = Repo.get!(Pin, id)
    user = User |> Repo.get!(user_id)
    bucket = Bucket |> Repo.get!(bucket_id)
    pin = Pin |> Repo.get!(id)
    changeset = Pin.changeset(pin)
    render(conn, :show, pin: pin, bucket: bucket, user: user, changeset: changeset)
  end

  def edit(conn, params, current_user) do
    %{"id" => id, "user_id" => user_id, "bucket_id" => bucket_id} = params

    user = User |> Repo.get!(user_id)
    bucket = Bucket |> Repo.get!(bucket_id)
    pin = Pin |> Repo.get!(id)
    changeset = Pin.changeset(pin)
    render(conn, :edit, pin: pin, bucket: bucket, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "pin" => pin_params}, current_user) do
    pin = Repo.get!(Pin, id)
    bucket = Repo.get!(Bucket, conn.params["bucket_id"])
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
    pin = Repo.get!(Pin, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(pin)

    conn
    |> put_flash(:info, "Pin deleted successfully.")
    |> redirect(to: user_bucket_pin_path(conn, current_user, :index, pin))
  end
end
