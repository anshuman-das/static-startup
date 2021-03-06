defmodule Pns.Repos.Event do
  @moduledoc """
  The Event repository.
  """

  import Ecto.Query, warn: false
  alias Pns.Repo

  alias Pns.Schema.{Event, Application}

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events(application_id) do
    Repo.all(from e in Event, where: e.application_id == ^application_id)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Gets a list of events by application_id.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_events_by_application_id!(123)
      [%Event{}]

      iex> get_events_by_application_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_events_by_application_id!(application_id) do
    from(
      event in Event,
      where: event.application_id == ^application_id
    )
    |> Repo.all()
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  @doc """
  Returns the list of active events.

  ## Examples

      iex> get_active_events()
      [%Event{}, ...]

  """
  def get_active_events() do
    date_time = DateTime.utc_now()

    Repo.all(
      from e in Event,
        join: applications in Application,
        on: e.application_id == applications.id,
        where: e.start_time <= ^date_time and e.end_time >= ^date_time,
        select: %{
          id: e.id,
          application_id: e.application_id,
          application_key: applications.key
        }
    )
  end

  @doc """
  Returns the list of active events.

  ## Examples

      iex> get_ending_events()
      [%Event{}, ...]

  """
  def get_ending_events() do
    date_time = DateTime.utc_now()

    Repo.all(
      from e in Event,
        join: applications in Application,
        on: e.application_id == applications.id,
        where: e.end_time == ^date_time,
        select: %{
          id: e.id,
          application_id: e.application_id,
          application_key: applications.key
        }
    )
  end
end
