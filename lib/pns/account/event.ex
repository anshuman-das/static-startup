defmodule Pns.Account.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @url_regex ~r/^(http|https):\/\/\w+(\.\w+)*(:[0-9]+)?\/?(\/[.\w]*)*$/

  schema "events" do
    field :end_time, :naive_datetime
    field :html_template, :string
    field :key, Ecto.UUID
    field :start_time, :naive_datetime
    field :website_url, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:website_url, :start_time, :end_time, :html_template, :user_id, :key])
    |> validate_required([:website_url, :start_time, :end_time, :html_template, :user_id, :key])
    |> validate_url_format(:website_url)
  end

  defp validate_url_format(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, url ->
      case Regex.match?(@url_regex, url) do
        true -> []
        false -> [{field, options[:message] || "Format invalid"}]
      end
    end)
  end
end
