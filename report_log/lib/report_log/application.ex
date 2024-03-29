defmodule ReportLog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      PGChannel.Repo,
      worker(ReportLog.ChannelListener, [
        "new_cart_created",
        [name: ReportLog.ChannelListener, restart: :permanent]
      ])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReportLog.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
