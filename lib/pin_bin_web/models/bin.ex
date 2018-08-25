defmodule PinBin.Bin do
  use PinBinWeb, :model

  @required_fields ~w(name short_name)a
  @optional_fields ~w()a

  schema "bins" do
    field :name, :string
    field :short_name, :string
    field :is_public, :boolean, default: false
    belongs_to :user, PinBin.User
    has_many :pins, PinBin.Pin

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:bins_user_id_short_name_index)
  end
end
