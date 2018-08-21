defmodule PinBinWeb.BucketController do
  use PinBinWeb, :controller

  alias PinBin.Bucket
  alias PinBin.User

  plug :scrub_params, "bucket" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id}, _current_user) do
    user = User |> Repo.get!(user_id)

    buckets =
      user
      |> assoc(:buckets)
      |> Repo.all
      |> Repo.preload(:user)

    render(conn, :index, buckets: buckets, user: user)
  end

  def new(conn, _params, current_user) do
    changeset = Bucket.changeset(%Bucket{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"bucket" => bucket_params}, current_user) do
    derived_bucket_params = bucket_params |> derive_params

    changeset =
      current_user
      |> build_assoc(:buckets)
      |> Bucket.changeset(derived_bucket_params)

    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Bucket was created successfully!")
        |> redirect(to: user_bucket_path(conn, :index, current_user))
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    bucket =
      Bucket
      |> Repo.get!(id)
      |> Repo.preload(:user)

    render(conn, :show, bucket: bucket, user: current_user)
  end

  def edit(conn, %{"id" => id}, current_user) do
    bucket = Bucket |> Repo.get!(id)

    changeset = Bucket.changeset(bucket)

    render(conn, :edit, bucket: bucket, changeset: changeset)
  end

  def update(conn, %{"id" => id, "bucket" => bucket_params}, current_user) do
    bucket = Bucket |> Repo.get!(id)
    derived_bucket_params = bucket_params |> derive_params
    changeset = Bucket.changeset(bucket, derived_bucket_params)

    case Repo.update(changeset) do
      {:ok, bucket} ->
        conn
        |> put_flash(:info, "Bucket was updated successfully!")
        |> redirect(to: user_bucket_path(conn, :show, current_user, bucket))
      {:error, changeset} ->
        render(conn, :edit, bucket: bucket, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    Bucket |> Repo.get!(id) |> Repo.delete!

    conn
    |> put_flash(:info, "Bucket was deleted successfully!")
    |> redirect(to: user_bucket_path(conn, :index, current_user))
  end

  defp derive_params(bucket_params) do
    short_name = case bucket_params["name"] do
      nil -> bucket_params
      _ -> bucket_params["name"]
           |> String.downcase
           |> String.trim
           |> String.replace(" ", "_")
    end

    Map.put(bucket_params, "short_name", short_name)
  end
end
