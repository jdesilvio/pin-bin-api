defmodule PinBinWeb.InspectConn do
  @moduledoc """
  Inspects a `conn`.
  Used for debugging.
  """
  import Plug.Conn

  def init(opts), do: opts

  @doc """
  Inspects a `conn`.
  """
  def call(conn, _opts) do
    IO.inspect conn
    conn
  end
end
