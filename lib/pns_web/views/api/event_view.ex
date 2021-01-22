defmodule PnsWeb.Api.EventView do
  use PnsWeb, :view
  use Timex

  alias PnsWeb.Api.EventView

  def render("events.json", %{events: events}) do
    render_many(
      events,
      EventView,
      "event.json"
    )
  end

  def render("event.json", %{event: nil}) do
    %{}
  end

  def render("event.json", %{event: event}) do
    %{
      name: event.name,
      html_template: event.html_template,
      start_time: event.start_time,
      end_time: event.end_time
    }
  end
end
