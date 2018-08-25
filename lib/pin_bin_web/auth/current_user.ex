defmodule PinBinWeb.CurrentUser do
  @moduledoc """
  Simple `Plug` to get the `current_user`
  from a `Guardian` token.
  """
  import Plug.Conn
  import Guardian.Plug

  def init(opts), do: opts

  @doc """
  Get the `current_user` from a `Guardian` token
  and assign it to `conn`.
  """
  def call(conn, _opts) do
    current_user = current_resource(conn)
    assign(conn, :current_user, current_user)
  end
end
