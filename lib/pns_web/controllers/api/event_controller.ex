defmodule PnsWeb.Api.EventController do
  use PnsWeb, :controller

  alias Pns.Account
  alias Pns.Account.Event

  def get_event_by_key(conn, %{"key" => key}) do
    event = Account.get_event_by_key!(key)
    render(conn, "event.json", event: event)
  end
end
