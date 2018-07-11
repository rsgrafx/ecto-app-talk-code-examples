defmodule ReportLog.ChannelListener do
  @moduledoc """
    Genserver that is managed by postgrex Notifcations supervisor.
  """
  use GenServer

  require Logger

  def start_link(channel, opts) do
    GenServer.start_link(__MODULE__, channel, opts)
  end

  def init(channel) do
    Logger.debug("Starting #{__MODULE__} with channel #{channel}")
    pg_config = PGChannel.Repo.config()
    {:ok, pid} = Postgrex.Notifications.start_link(pg_config)
    {:ok, ref} = Postgrex.Notifications.listen(pid, channel)

    {:ok, {pid, channel, ref}}
  end

  def handle_info({:notification, _, _, "new_cart_created", payload}, _state) do
    IO.inspect(Poison.decode!(payload))
    {:noreply, :event_handled}
  end

  def handle_info(_, _state), do: {:noreply, :event_received}
end
