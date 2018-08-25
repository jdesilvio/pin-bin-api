defmodule PinBin.Repo.Migrations.CreatePin do
  use Ecto.Migration

  def change do
    create table(:pins) do
      add :name, :string
      add :latitude, :float
      add :longitude, :float
      add :user_id, references(:users, on_delete: :delete_all)
      add :bin_id, references(:bins, on_delete: :delete_all)

      timestamps()
    end

  end
end
