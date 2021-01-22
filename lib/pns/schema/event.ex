defmodule Pns.Schema.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :end_time, :naive_datetime
    field :html_template, :string
    field :start_time, :naive_datetime
    field :user_id, :id
    field :application_id, :id
    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :start_time, :end_time, :html_template, :user_id, :application_id])
    |> validate_required([
      :name,
      :start_time,
      :end_time,
      :html_template,
      :user_id,
      :application_id
    ])
  end
end
