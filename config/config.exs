# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :recruitbot, Recruitbot.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "sCYIM/fJrDG0FBAZgVuK0CquWaaFfYLE48DBaEkoXhmcrrRsXGNa6AlYFaZWDqMg",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Recruitbot.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :recruitbot, :dj_opts,
  tty: System.get_env("SERIAL") || '/dev/ttyUSB0',
  speed: 115_200,
  listen_to: [:bumps_and_wheeldrops, :light_bumper],
  listen_interval: 33

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
