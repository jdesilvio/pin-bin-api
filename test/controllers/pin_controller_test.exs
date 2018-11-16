defmodule PinBinWeb.PinControllerTest do
  use PinBinWeb.ConnCase

  import Phoenix.ConnTest
  alias PinBin.Factory
  alias PinBin.Pin

  @api_path "/api/v1"
  @valid_attrs %{latitude: "120.5", longitude: "120.5", name: "some pin"}
  @invalid_attrs %{latitude: nil, longitude: nil, name: nil}

  setup %{conn: conn} do
    user = Factory.insert(:user)
    bin = Factory.insert(:bin, user: user)
    {:ok, jwt, _} = Guardian.encode_and_sign(user)
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer " <> jwt)
    {:ok, %{conn: conn, user: user, bin: bin, jwt: jwt}}
  end

  describe "index/3" do
    test "lists pins", %{conn: conn, user: user, bin: bin} do
      pin = Factory.insert(:pin, user: user, bin: bin)

      path = @api_path <> user_bin_pin_path(conn, :index, user, bin)
      response =
        conn
        |> get(path)
        |> json_response(200)

      assert response == %{
        "data" => [
          %{
            "id" => pin.id,
            "latitude" => pin.latitude,
            "longitude" => pin.longitude,
            "name" => pin.name
          }
        ]
      }
    end

    test "list only pins associated with bin", %{conn: conn, user: user} do
      bin1 = Factory.insert(:bin, user: user)
      bin2 = Factory.insert(:bin, user: user)

      pin1 = Factory.insert(:pin, user: user, bin: bin1)
      pin2 = Factory.insert(:pin, user: user, bin: bin1)
      pin3 = Factory.insert(:pin, user: user, bin: bin2)
      pin4 = Factory.insert(:pin, user: user, bin: bin2)

      path = @api_path <> user_bin_pin_path(conn, :index, user, bin1)
      response =
        conn
        |> get(path)
        |> json_response(200)

      %{"data" => pins} = response
      assert length(pins) == 2
      assert Enum.at(pins, 0)["id"] in [pin1.id, pin2.id]
      assert Enum.at(pins, 1)["id"] in [pin1.id, pin2.id]
    end
  end

  describe "create/3" do
    test "new pin is created", %{conn: conn, user: user, bin: bin} do
      path = @api_path <> user_bin_pin_path(conn, :create, user, bin, pin: @valid_attrs)
      response =
        conn
        |> post(path)
        |> json_response(201)

      %{"data" => pin} = response
      assert pin["name"] == @valid_attrs.name
      assert {pin["latitude"], ""} == Float.parse(@valid_attrs.latitude)
      assert {pin["longitude"], ""} == Float.parse(@valid_attrs.longitude)
    end

    test "new pin is not created with invalid attributes", %{conn: conn, user: user, bin: bin} do
      path = @api_path <> user_bin_pin_path(conn, :create, user, bin, pin: @invalid_attrs)
      response =
        conn
        |> post(path)
        |> json_response(422)

      assert response["status"] == "error"
      assert response["message"] == "An error occurred."
    end
  end

  describe "show/3" do
    test "show pin", %{conn: conn, user: user, bin: bin} do
      pin = Factory.insert(:pin, user: user, bin: bin)

      path = @api_path <> user_bin_pin_path(conn, :show, user, bin, pin)
      response =
        conn
        |> get(path)
        |> json_response(200)

      assert response == %{
        "data" => %{
          "id" => pin.id,
          "name" => pin.name,
          "latitude" => pin.latitude,
          "longitude" => pin.longitude
        }
      }
    end
  end

  describe "update/3" do
    test "update pin", %{conn: conn, user: user, bin: bin} do
      pin = Factory.insert(:pin, user: user, bin: bin)
      new_params = %{"name" => "new xxx name", "longitude" => 11}

      path = @api_path <> user_bin_pin_path(conn, :update, user, bin.id, pin.id, pin: new_params)
      response =
        conn
        |> patch(path)
        |> json_response(200)

      assert response == %{
        "data" => %{
          "id" => pin.id,
          "name" => new_params["name"],
          "latitude" => pin.latitude,
          "longitude" => new_params["longitude"]
        }
      }
    end
  end

  describe "delete/3" do
    test "delete pin", %{conn: conn, user: user, bin: bin} do
      pin = Factory.insert(:pin, user: user, bin: bin)

      path = @api_path <> user_bin_pin_path(conn, :delete, user, bin, pin)
      response =
        conn
        |> delete(path)
        |> response(204)

      assert response == ""
      refute Repo.get(Pin, pin.id)
    end
  end
end
