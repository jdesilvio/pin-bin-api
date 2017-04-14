defmodule Blaces.AuthView do
  use Blaces.Web, :view

  def render("login.json", %{auth: auth}) do
    %{data: render_one(auth, Blaces.AuthView, "auth.json")}
  end

  def render("auth.json", %{auth: auth}) do
    %{auth: auth}
  end

end
