defmodule Blaces.UserView do
  use Blaces.Web, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Blaces.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      username: user.username}
  end

end
