defmodule Pns.Repo do
  use Ecto.Repo,
    otp_app: :pns,
    adapter: Ecto.Adapters.Postgres
end
