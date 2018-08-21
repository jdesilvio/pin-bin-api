defmodule PinBinWeb.AuthView do
  use PinBinWeb, :view

  def render("login.json", %{jwt: jwt, exp: exp, token_type: token_type}) do
    %{jwt: jwt, exp: exp, token_type: token_type}
  end

end
