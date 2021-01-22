defmodule Pns.Services.EventService do
  @moduledoc """
  The Event service.
  """

  alias Pns.Repos.Event

  def list_events(application_id) do
    Event.list_events(application_id)
  end

  def get_event(id) do
    Event.get_event!(id)
  end

  def get_events_by_application_id(application_id) do
    Event.get_events_by_application_id!(application_id)
  end

  def create_event(attr) do
    Event.create_event(attr)
  end

  def update_event(event, attr) do
    Event.update_event(event, attr)
  end

  def delete_event(event) do
    Event.delete_event(event)
  end

  def change_event(event) do
    Event.change_event(event)
  end

  def get_all_active_events() do
    Event.get_active_events()
  end

  def change_event_from_utc_to_local_time(event) do
    naive_utc_now = NaiveDateTime.utc_now()
    naive_local_now = NaiveDateTime.local_now()

    event
    |> Map.put(
      :start_time,
      NaiveDateTime.add(event.start_time, NaiveDateTime.diff(naive_local_now, naive_utc_now))
    )
    |> Map.put(
      :end_time,
      NaiveDateTime.add(event.end_time, NaiveDateTime.diff(naive_local_now, naive_utc_now))
    )
  end

  def change_event_params_from_local_to_utc_time(event_params) do
    naive_utc_now = NaiveDateTime.utc_now()
    naive_local_now = NaiveDateTime.local_now()

    start_time = event_params["start_time"]

    {:ok, start_time} =
      NaiveDateTime.new(
        String.to_integer(start_time["year"]),
        String.to_integer(start_time["month"]),
        String.to_integer(start_time["day"]),
        String.to_integer(start_time["hour"]),
        String.to_integer(start_time["minute"]),
        0
      )

    end_time = event_params["end_time"]

    {:ok, end_time} =
      NaiveDateTime.new(
        String.to_integer(end_time["year"]),
        String.to_integer(end_time["month"]),
        String.to_integer(end_time["day"]),
        String.to_integer(end_time["hour"]),
        String.to_integer(end_time["minute"]),
        0
      )

    event_params
    |> Map.put(
      "start_time",
      NaiveDateTime.add(start_time, NaiveDateTime.diff(naive_utc_now, naive_local_now))
    )
    |> Map.put(
      "end_time",
      NaiveDateTime.add(end_time, NaiveDateTime.diff(naive_utc_now, naive_local_now))
    )
  end
end
