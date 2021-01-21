defmodule Pns.Account.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @url_regex ~r/^(http|https):\/\/\w+(\.\w+)*(:[0-9]+)?\/?(\/[.\w]*)*$/

  schema "events" do
    field :end_time, :naive_datetime
    field :html_template, :string
    field :start_time, :naive_datetime
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:start_time, :end_time, :html_template, :user_id])
    |> validate_required([:start_time, :end_time, :html_template, :user_id])
  end
end
