defmodule Blaces.Pin do
  use Blaces.Web, :model

  schema "pins" do
    field :name, :string
    field :latitude, :float
    field :longitude, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :latitude, :longitude])
    |> validate_required([:name, :latitude, :longitude])
  end
end
