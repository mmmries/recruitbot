defmodule Recruitbot.DJSupervisor do
  use Supervisor
  require Logger

  def start_link(dj_opts) do
    Supervisor.start_link(__MODULE__, [dj_opts], name: __MODULE__)
  end

  def init(dj_opts) do
    publisher_pid = spawn_link(__MODULE__, publish_roomba_updates, [])

    dj_opts = Keyword.put(dj_opts, :report_to, publisher_pid)
    children = [
      worker(Roombex.DJ, [dj_opts])
    ]
    supervise(children, strategy: :one_for_all)
  end

  defp publish_roomba_updates do
    receive do
      {:roomba_status, roombex_sensors} ->
        Recruitbot.Endpoint.broadcast("roomba", "sensor_update", sensors_to_map(roombex_sensors))
      msg -> Logger.error("#{__MODULE__} Received unexpected message #{inspect msg}")
    end
    publish_roomba_updates
  end

  defp sensors_to_map(sensors) do
    Map.take(sensors, [:bumper_left, :bumper_right, :light_bumper_left, :light_bumper_left_front, :light_bumper_left_center, :light_bumper_right_center, :light_bumper_right_front, :light_bumper_right])
  end
end
