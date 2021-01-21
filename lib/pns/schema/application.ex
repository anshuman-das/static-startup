defmodule Pns.Schema.Application do
  use Ecto.Schema
  import Ecto.Changeset

  @url_regex ~r/^(http|https):\/\/\w+(\.\w+)*(:[0-9]+)?\/?(\/[.\w]*)*$/
  schema "applications" do
    field :url, :string
    field :name, :string
    field :description, :string
    field :key, Ecto.UUID
    field :creator_id, :id

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:url, :name, :key, :description, :creator_id])
    |> validate_required([:url, :name, :key, :creator_id])
    |> validate_url_format(:url)
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
