defmodule PnsWeb.Api.EventController do
  use PnsWeb, :controller

  alias Pns.Services.Api.EventService

  def get_all_events_by_application_key(conn, %{"key" => key}) do
    events = EventService.get_all_events_by_application_key(key)
    render(conn, "events.json", events: events)
  end

  def get_current_event_by_application_key(conn, %{"key" => key}) do
    current_event = EventService.get_current_event_by_application_key(key)
    render(conn, "event.json", event: current_event)
  end
end
