defmodule PinBinWeb.AssignCurrentUser do
  @moduledoc """
  Assign the current user to a connection.
  """
  import Plug.Conn
  alias PinBin.Accounts

  def init(opts), do: opts

  @doc """
  Get current user and assign it to a connection.
  """
  def call(conn, _opts) do
    if Map.get(conn.assigns, :current_user) do
      conn
    else
      %{"user_id" => user_id} = conn.params
      current_user = Accounts.get_user!(user_id)
      conn |> assign(:current_user, current_user)
    end
  end
end
