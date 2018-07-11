# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :report_log, ecto_repos: [PGChannel.Repo]

config :report_log, PGChannel.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "postgres://postgres@localhost:5432/core_orders"
