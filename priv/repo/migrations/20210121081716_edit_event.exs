defmodule Pns.Repo.Migrations.EditEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add(:application_id, references(:applications, on_delete: :delete_all))
      remove(:website_url)
      remove(:key)
    end

    create index(:events, [:application_id])
  end
end
