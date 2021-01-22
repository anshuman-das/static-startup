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
end
