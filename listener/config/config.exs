# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :listener, ecto_repos: [Listener.Repo, Listener.Reviews.Repo]

config :listener, Listener.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "postgres://postgres@localhost:5432/core_orders"

config :listener, Listener.Reviews.Repo,
  adapter: Ecto.Adapters.Postgres,
  user: "postgres",
  database: "reviews",
  hostname: "localhost"
