defmodule Pns.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :website_url, :string
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime
      add :html_template, :text
      add :key, :uuid
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:events, [:user_id])
  end
end
