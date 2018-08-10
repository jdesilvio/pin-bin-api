defmodule BlacesWeb.AuthView do
  use BlacesWeb, :view

  def render("login.json", %{jwt: jwt, exp: exp, token_type: token_type}) do
    %{jwt: jwt, exp: exp, token_type: token_type}
  end

end
