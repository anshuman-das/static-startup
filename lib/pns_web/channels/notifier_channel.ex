defmodule PnsWeb.NotifierChannel do
  use PnsWeb, :channel

  def join("notifier:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new_msg", %{"uid" => uid, "body" => body}, socket) do
    broadcast_from!(socket, "new_msg", %{uid: uid, body: body})
    Pns.Endpoint.broadcast_from!(self(), "room:superadmin", "new_msg", %{uid: uid, body: body})
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (notifier:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
