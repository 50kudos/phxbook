# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phxbook,
  ecto_repos: [Phxbook.Repo]

# Configures the endpoint
config :phxbook, Phxbook.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8bHsj9ZX6fTlbGaB+K0xaaBufxwJF3zc5OZb20+cxAsjM2mU/dOZtyB5d43k+3RF",
  render_errors: [view: Phxbook.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phxbook.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
