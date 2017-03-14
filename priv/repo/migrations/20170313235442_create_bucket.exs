defmodule Blaces.Repo.Migrations.CreateBucket do
  use Ecto.Migration

  def change do
    create table(:buckets) do
      add :name, :string, null: false
      add :short_name, :string, null: false
      add :is_public, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create unique_index(:buckets, [:user_id, :short_name])

  end
end
