defmodule PinBinWeb.ElmController do
  use PinBinWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
