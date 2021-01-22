# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pns,
  ecto_repos: [Pns.Repo]

config :pns, Oban,
  repo: Pns.Repo,
  queues: [default: 1],
  crontab: [
    {"* * * * *", Support.Workers.MinuteWorker}
  ]

# Configures the endpoint
config :pns, PnsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QSIFVcltPjpbAS6GQSPR4jekQ+b2XYGaLkOaUNx6vLT4uxf0hMU2fOtZOUi7ix8z",
  render_errors: [view: PnsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pns.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "fFQPl6Si"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Ueberauth Config
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  redirect_uri: System.get_env("REDIRECT_URI")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
