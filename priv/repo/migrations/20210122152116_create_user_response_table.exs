defmodule Pns.Repo.Migrations.CreateUserResponseTable do
  use Ecto.Migration

  def change do
    create table(:user_responses) do
      add :question_text, :text
      add :response, :text
      add :event_id, references(:events, on_delete: :delete_all)
      add :user, :text
      timestamps()
    end

    create index(:user_responses, [:event_id, :user])
  end
end
