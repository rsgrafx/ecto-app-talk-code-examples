# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :smoke_shop,
  ecto_repos: [SmokeShop.Repo]

# Configures the endpoint
config :smoke_shop, SmokeShopWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "406lPuohwOaT7qVvOjc87OYweMO2shixNhozAOCD4OSkEglhd/Vl3R1NxVckLEsI",
  render_errors: [view: SmokeShopWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SmokeShop.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
