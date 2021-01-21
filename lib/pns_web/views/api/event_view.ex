defmodule PnsWeb.Api.EventView do
  use PnsWeb, :view

  def render("event.json", %{event: event}) do
    %{
      html_template: event.html_template,
      start_time: event.start_time,
      end_time: event.end_time
    }
  end
end
