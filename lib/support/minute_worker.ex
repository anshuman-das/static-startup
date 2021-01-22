defmodule Support.Workers.MinuteWorker do
  use Oban.Worker, max_attempts: 3

  alias Pns.Services.EventService

  @impl Oban.Worker
  def perform(_) do
    events = EventService.get_all_active_events() |> IO.inspect(label: "--")
    {:ok, events}
  end
end
