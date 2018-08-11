defmodule BlacesWeb.BucketControllerTest do
  use BlacesWeb.ConnCase

  import Phoenix.ConnTest
  alias Blaces.User
  alias Blaces.Bucket
  alias Blaces.Repo
  alias Blaces.Factory

  @valid_attrs %{"name" => "my bucket"}

  describe "index/3" do
    test "list buckets" do
      user = Factory.insert(:user)
      bucket1 = Factory.insert(:bucket, user: user)
      bucket2 = Factory.insert(:bucket, user: user)

      conn =
        session_conn(user)
        |> get(user_bucket_path(conn, :index, user))

      html = html_response(conn, 200)
      assert html =~ bucket1.name
      assert html =~ bucket2.name
    end

    test "only lists current user's buckets" do
      user1 = Factory.insert(:user)
      user2 = Factory.insert(:user)
      bucket1 = Factory.insert(:bucket, user: user1)
      bucket2 = Factory.insert(:bucket, user: user2)

      conn =
        session_conn(user1)
        |> get(user_bucket_path(conn, :index, user1))

      html = html_response(conn, 200)
      assert html =~ bucket1.name
      refute html =~ bucket2.name
    end
  end

  describe "new/3" do
    test "new bucket" do
      user = Factory.insert(:user)

      conn =
        session_conn(user)
        |> get(user_bucket_path(conn, :new, user))

      html = html_response(conn, 200)
      assert html =~ "Create Bucket"
    end
  end

  describe "create/3" do
    test "create bucket" do
      user = Factory.insert(:user)

      conn =
        session_conn(user)
        |> post(user_bucket_path(conn, :create, user, bucket: @valid_attrs))

      assert get_flash(conn)["info"] == "Bucket was created successfully!"

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      html = html_response(conn, 200)
      assert html =~ @valid_attrs["name"]
    end
  end

  describe "show/3" do
    test "show bucket" do
      user = Factory.insert(:user)
      bucket = Factory.insert(:bucket, user: user)

      conn =
        session_conn(user)
        |> get(user_bucket_path(conn, :show, user.id, bucket.id))

      html = html_response(conn, 200)
      assert html =~ bucket.name
    end
  end

  describe "edit/3" do
    test "edit bucket" do
      user = Factory.insert(:user)
      bucket = Factory.insert(:bucket, user: user)

      conn =
        session_conn(user)
        |> get(user_bucket_path(conn, :edit, user, bucket))

      html = html_response(conn, 200)
      assert html =~ "Edit Bucket"
      assert html =~ bucket.name
    end
  end

  describe "update/3" do
    test "update bucket" do
      user = Factory.insert(:user)
      bucket = Factory.insert(:bucket, user: user)
      new_params = %{"name" => "new name"}
      new_bucket = %{bucket | name: "new name"}
      IO.inspect new_bucket

      conn =
        session_conn(user)
        |> patch(user_bucket_path(conn, :update, user, bucket.id, bucket: new_params))

      assert get_flash(conn)["info"] == "Bucket was updated successfully!"

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      html = html_response(conn, 200)
      assert html =~ "new name"
      refute html =~ bucket.name
    end
  end

  describe "delete/3" do
    test "delete bucket" do
      user = Factory.insert(:user)
      bucket = Factory.insert(:bucket, user: user)

      conn =
        session_conn(user)
        |> delete(user_bucket_path(conn, :delete, user, bucket))

      assert get_flash(conn)["info"] == "Bucket was deleted successfully!"

      redir_path = redirected_to(conn)
      conn = get(recycle(conn), redir_path)

      html = html_response(conn, 200)
      refute html =~ bucket.name
    end
  end
end
