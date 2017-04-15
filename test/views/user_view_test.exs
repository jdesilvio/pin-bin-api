defmodule Blaces.UserViewTest do
  use Blaces.ConnCase, async: true

  import Phoenix.View

  alias Blaces.User

  @user %User{}

  test "renders show.json" do
    assert render(Blaces.UserView, "show.json", %{user: @user}) ==
      %{data: %{email: nil, id: nil, username: nil}}
  end

  test "renders user.json" do
    assert render(Blaces.UserView, "user.json", %{user: @user}) ==
      %{email: nil, id: nil, username: nil}
  end
end
