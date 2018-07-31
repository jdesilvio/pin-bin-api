defmodule Blaces.BucketControllerTest do
  use Blaces.ConnCase

  import Phoenix.ConnTest
  alias Blaces.User
  alias Blaces.Bucket
  alias Blaces.Repo
  alias Blaces.Factory

  @bucket %Bucket{id: 1, name: "some bucket"}

  describe "index/3" do
    test 'list buckets', %{conn: conn} do
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

    test 'only lists current user\'s buckets', %{conn: conn} do
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
    test 'new bucket' do
      user = Factory.insert(:user)

      conn =
        session_conn(user)
        |> get(user_bucket_path(conn, :new, user))

      html = html_response(conn, 200)
      assert html =~ "Create Bucket"
    end
  end

  describe "create/3" do
    test 'create bucket' do
    #      user = Factory.insert(:user)
    #
    #      conn =
    #        session_conn(user)
    #        |> get(user_bucket_path(conn, :create, user, @bucket))
    #
    #      assert get_flash(conn)["info"] == "#{@bucket.name} created!"
    #
    #      html = html_response(conn, 200)
    #      assert html =~ "#{@bucket.name}"
    end
  end

  describe "show/3" do
    test 'show bucket' do
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
    test 'edit bucket' do
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
    test 'update bucket' do
      user = Factory.insert(:user)
      bucket = Factory.insert(:bucket, user: user)

      conn =
        session_conn(user)
        |> get(user_bucket_path(conn, :update, user, %Bucket{id: bucket.id, name: "new name"}))

      html = html_response(conn, 200)
      assert html =~ "new name"
      refute html =~ bucket.name
    end
  end

  describe "delete/3" do
    test 'delete bucket' do
      user = Factory.insert(:user)
      bucket = Factory.insert(:bucket, user: user)

      conn =
        session_conn(user)
        |> get(user_bucket_path(conn, :delete, user, bucket))

      html = html_response(conn, 200)
      assert html =~ "Really?"
    end
  end
end
