defmodule PnsWeb.Api.EventController do
  use PnsWeb, :controller

  alias Pns.Services.ApplicationService
  alias Pns.Services.EventService

  def get_all_events_by_application_key(conn, %{"key" => key}) do
    application = ApplicationService.get_application_by_key(key)
    events = EventService.get_events_by_application_id(application.id)
    render(conn, "events.json", events: events)
  end

  def get_current_event_by_application_key(conn, %{"key" => key}) do
    application = ApplicationService.get_application_by_key(key)
    events = EventService.get_events_by_application_id(application.id)

    current_event =
      events
      |> Enum.filter(fn event ->
        event.start_time >= NaiveDateTime.utc_now() &&
          event.end_time <= NaiveDateTime.utc_now()
      end)
      |> List.first()

    render(conn, "event.json", event: current_event)
  end
end
