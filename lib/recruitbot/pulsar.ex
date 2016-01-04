defmodule Recruitbot.Pulsar do
  use GenServer
  alias Roombex.DJ

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(nil) do
    :timer.send_interval(100, :pulse)
    {:ok, %{}}
  end

  def handle_info(:pulse, state) do
    DJ.command(:dj, Roombex.leds([], current_color(), 1.0))
    {:noreply, state}
  end

  defp current_color do
    fractional_epoch = :os.system_time / 1000000000.0
    (:math.sin(fractional_epoch) + 1.0) / 2.0
  end
end
