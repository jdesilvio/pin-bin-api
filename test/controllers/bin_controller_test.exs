defmodule PinBinWeb.BinControllerTest do
  use PinBinWeb.ConnCase

  import Phoenix.ConnTest
  alias PinBin.Factory

  @api_path "/api/v1"
  @valid_attrs %{"name" => "my bin", "is_public" => true}

  setup %{conn: conn} do
    user = Factory.insert(:user)
    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer " <> jwt)
    {:ok, %{conn: conn, user: user, jwt: jwt}}
  end

  describe "index/3" do
    test "list bins", %{conn: conn, user: user} do
      bin1 = Factory.insert(:bin, user: user)
      bin2 = Factory.insert(:bin, user: user)

      path = @api_path <> user_bin_path(conn, :index, user)
      response =
        conn
        |> get(path)
        |> json_response(200)

      assert response == %{
        "data" => [
            %{
              "id" => bin1.id,
              "is_public" => bin1.is_public,
              "name" => bin1.name,
              "short_name" => bin1.short_name
            },
            %{
              "id" => bin2.id,
              "is_public" => bin2.is_public,
              "name" => bin2.name,
              "short_name" => bin2.short_name
            }
          ]
        }
    end

    test "only lists current user's bins", %{conn: conn, user: user} do
      user2 = Factory.insert(:user)
      bin1 = Factory.insert(:bin, user: user)
      bin2 = Factory.insert(:bin, user: user2)

      path = @api_path <> user_bin_path(conn, :index, user)
      response =
        conn
        |> get(path)
        |> json_response(200)

      assert response == %{
        "data" => [
            %{
              "id" => bin1.id,
              "is_public" => bin1.is_public,
              "name" => bin1.name,
              "short_name" => bin1.short_name
            }
          ]
        }
    end
  end

  describe "create/3" do
    test "create bin", %{conn: conn} do
      user = Factory.insert(:user)

      path = @api_path <> user_bin_path(conn, :create, user, bin: @valid_attrs)
      response =
        conn
        |> post(path)
        |> json_response(201)

      assert response["data"]["name"] == @valid_attrs["name"]
    end
  end

  describe "show/3" do
    test "show bin", %{conn: conn} do
      user = Factory.insert(:user)
      bin = Factory.insert(:bin, user: user)

      path = @api_path <> user_bin_path(conn, :show, user.id, bin.id)
      response =
        conn
        |> get(path)
        |> json_response(200)

      assert response == %{
        "data" => %{
          "id" => bin.id,
          "is_public" => bin.is_public,
          "name" => bin.name,
          "short_name" => bin.short_name
        }
      }
    end
  end

  describe "update/3" do
    test "update bin", %{conn: conn, user: user} do
      bin = Factory.insert(:bin, user: user)
      new_params = %{"name" => "new name"}

      path = @api_path <> user_bin_path(conn, :update, user, bin.id, bin: new_params)
      response =
        conn
        |> patch(path)
        |> json_response(200)

      assert response == %{
        "data" => %{
          "id" => bin.id,
          "is_public" => bin.is_public,
          "name" => "new name",
          "short_name" => "new_name"
        }
      }
    end
  end

  describe "delete/3" do
    test "delete bin", %{conn: conn, user: user} do
      bin = Factory.insert(:bin, user: user)

      path =  @api_path <> user_bin_path(conn, :delete, user, bin)
      response =
        conn
        |> delete(path)
        |> response(204)

      assert response == ""
    end
  end
end
