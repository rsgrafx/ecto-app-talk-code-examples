defmodule Listener.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      Listener.Repo,
      Listener.Reviews.Repo,
      worker(
        Listener.PubSubWorker,
        ["new_order_created", [name: Listener.PubSubWorker, restart: :permanent]]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Listener.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
