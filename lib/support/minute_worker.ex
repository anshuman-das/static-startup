defmodule Support.Workers.MinuteWorker do
  use Oban.Worker, max_attempts: 3

  alias Pns.Services.EventService

  @impl Oban.Worker
  def perform(_) do
    events =
      EventService.get_all_active_events()
      |> IO.inspect(label: "--")
      |> IO.inspect(label: "events==> ")

    ending_events =
      EventService.get_ending_events()
      |> IO.inspect(label: "Ended events==> ")

    events
    |> Enum.map(fn event ->
      event_details = %{
        application_id: event.application_id,
        id: event.id,
        application_key: event.application_key
      }

      #  Pns.Endpoint.broadcast!("notifier:" <> rid, "new_msg", %{uid: "uid", body: "body"})
      PnsWeb.Endpoint.broadcast!("notifier:lobby", "event_started", %{
        uid: "uid",
        body: event_details
      })
      |> IO.inspect(label: "Inspect : ")
    end)

    ending_events
    |> Enum.map(fn event ->
      event_details = %{
        application_id: event.application_id,
        id: event.id,
        application_key: event.application_key
      }

      #  Pns.Endpoint.broadcast!("notifier:" <> rid, "new_msg", %{uid: "uid", body: "body"})
      PnsWeb.Endpoint.broadcast!("notifier:lobby", "event_ended", %{
        uid: "uid",
        body: event_details
      })
      |> IO.inspect(label: "Inspect : ")
    end)

    {:ok, events}
  end
end
