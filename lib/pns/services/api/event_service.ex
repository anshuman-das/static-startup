defmodule Pns.Services.Api.EventService do
  @moduledoc """
  The Event service Api.
  """

  alias Pns.Services.ApplicationService
  alias Pns.Services.EventService

  def get_all_events_by_application_key(key) do
    application = ApplicationService.get_application_by_key(key)
    EventService.get_events_by_application_id(application.id)
  end

  def get_current_event_by_application_key(key) do
    application = ApplicationService.get_application_by_key(key)

    EventService.get_events_by_application_id(application.id)
    |> Enum.filter(fn event ->
      event.start_time >= NaiveDateTime.utc_now() &&
        event.end_time <= NaiveDateTime.utc_now()
    end)
    |> List.first()
  end
end
