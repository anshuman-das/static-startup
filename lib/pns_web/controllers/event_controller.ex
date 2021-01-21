defmodule PnsWeb.EventController do
  use PnsWeb, :controller

  alias Pns.Services.EventService
  alias Pns.Schema.Event

  def index(conn, %{"application_id" => application_id}) do
    case Plug.Conn.get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Please Login")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        events =
          EventService.list_events()
          |> Enum.filter(fn x -> x.user_id == Plug.Conn.get_session(conn, :user_id) end)

        render(conn, "index.html", data: %{events: events, application_id: application_id})
    end
  end

  def new(conn, %{"application_id" => application_id}) do
    case Plug.Conn.get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Please Login")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        changeset = EventService.change_event(%Event{})
        render(conn, "new.html", data: %{changeset: changeset, application_id: application_id})
    end
  end

  def create(conn, %{"application_id" => application_id, "event" => event_params}) do
    event_params =
      event_params
      |> Map.put("user_id", Plug.Conn.get_session(conn, :user_id))
      |> Map.put("application_id", application_id)
      |> IO.inspect(label: ">>>>>>>>>>")

    case EventService.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.application_event_path(conn, :show, event.application_id, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Plug.Conn.get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Please Login")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        event = EventService.get_event(id)
        render(conn, "show.html", event: event)
    end
  end

  def edit(conn, %{"id" => id}) do
    case Plug.Conn.get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Please Login")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        event = EventService.get_event(id)
        changeset = EventService.change_event(event)
        render(conn, "edit.html", event: event, changeset: changeset)
    end
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
