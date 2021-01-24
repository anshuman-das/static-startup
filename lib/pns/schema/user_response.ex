defmodule Pns.Schema.UserResponse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_responses" do
    field :question_text, :string
    field :response, :string
    field :event_id, :id
    field :user, :string
    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:question_text, :response, :event_id, :user])
    |> validate_required([
      :response,
      :user,
      :event_id
    ])
  end
end
