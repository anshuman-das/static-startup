defmodule PnsWeb.EventController do
  use PnsWeb, :controller

  alias Pns.Account
  alias Pns.Account.Event

  def index(conn, _params) do
    case Plug.Conn.get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Please Login in")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        events =
          Account.list_events()
          |> Enum.filter(fn x -> x.user_id == Plug.Conn.get_session(conn, :user_id) end)

        render(conn, "index.html", events: events)
    end
  end

  def new(conn, _params) do
    changeset = Account.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    event_params =
      event_params
      |> Map.put("user_id", Plug.Conn.get_session(conn, :user_id))
      |> Map.put("key", UUID.uuid4())

    case Account.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Account.get_event!(id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Account.get_event!(id)
    changeset = Account.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Account.get_event!(id)

    case Account.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Account.get_event!(id)
    {:ok, _event} = Account.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end
end
