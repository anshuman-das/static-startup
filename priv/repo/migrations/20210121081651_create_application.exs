defmodule Pns.Repo.Migrations.CreateApplication do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :url, :string
      add :name, :text
      add :description, :text
      add :creator_id, references(:users, on_delete: :nilify_all)
      add :key, :uuid
      timestamps()
    end

    create index(:applications, [:creator_id])
  end
end
