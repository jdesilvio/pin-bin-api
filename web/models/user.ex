defmodule Blaces.User do
  use Blaces.Web, :model

  @required_fields ~w(email username password_hash)a
  @optional_fields ~w()a

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:user_email_index)
    |> unique_constraint(:user_username_index)
  end
end
