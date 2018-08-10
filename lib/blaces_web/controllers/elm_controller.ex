defmodule BlacesWeb.ElmController do
  use Blaces.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
