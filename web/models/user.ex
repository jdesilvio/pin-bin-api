defmodule Blaces.User do
  use Blaces.Web, :model

  schema "users" do
    field :email, :string
    field :username, :string
    field :password_hash, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :username, :password_hash])
    |> validate_required([:email, :username, :password_hash])
    |> unique_constraint(:user_email_index)
    |> unique_constraint(:user_username_index)
  end
end
