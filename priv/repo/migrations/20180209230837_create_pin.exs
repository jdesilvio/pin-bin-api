defmodule PinBin.Repo.Migrations.CreatePin do
  use Ecto.Migration

  def change do
    create table(:pins) do
      add :name, :string
      add :latitude, :float
      add :longitude, :float
      add :user_id, references(:users, on_delete: :delete_all)
      add :bucket_id, references(:buckets, on_delete: :delete_all)

      timestamps()
    end

  end
end
