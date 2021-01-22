defmodule PnsWeb.EventController do
  use PnsWeb, :controller

  alias Pns.Services.EventService
  alias Pns.Schema.Event

  def index(conn, %{"application_id" => application_id}) do
    events = EventService.list_events(application_id)

    render(conn, "index.html", data: %{events: events, application_id: application_id})
  end

  def new(conn, %{"application_id" => application_id}) do
    changeset = EventService.change_event(%Event{})
    render(conn, "new.html", data: %{changeset: changeset, application_id: application_id})
  end

  def create(conn, %{"application_id" => application_id, "event" => event_params}) do
    event_params =
      event_params
      |> Map.put("user_id", Plug.Conn.get_session(conn, :user_id))
      |> Map.put("application_id", application_id)

    case EventService.create_event(event_params) do
      {:ok, event} ->
        #  Pns.Endpoint.broadcast!("notifier:" <> rid, "new_msg", %{uid: "uid", body: "body"})
        PnsWeb.Endpoint.broadcast!("notifier:lobby", "new_msg", %{
          uid: "uid",
          body: "Time to show event: "
        })
        |> IO.inspect(label: "notifier:lobby ==> : ")

        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.application_event_path(conn, :show, event.application_id, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = EventService.get_event(id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = EventService.get_event(id)
    changeset = EventService.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = EventService.get_event(id)

    case EventService.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.application_event_path(conn, :show, event.application_id, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = EventService.get_event(id)
    {:ok, _event} = EventService.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.application_event_path(conn, :index, event.application_id))
  end
end
