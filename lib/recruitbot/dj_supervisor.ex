defmodule Recruitbot.DJSupervisor do
  use Supervisor
  require Logger

  @bumper_sensors [
    :bumper_left,
    :bumper_right,
    :light_bumper_left,
    :light_bumper_left_front,
    :light_bumper_left_center,
    :light_bumper_right_center,
    :light_bumper_right_front,
    :light_bumper_right,
  ]

  @battery_sensors [
    :battery_capacity,
    :battery_charge,
  ]

  def start_link(dj_opts) do
    Supervisor.start_link(__MODULE__, dj_opts, name: __MODULE__)
  end

  def init(dj_opts) do
    publisher_pid = spawn_link(&publish_roomba_updates/0)
    Process.register(publisher_pid, :publisher)

    :timer.send_interval(33, :dj, {:check_on, @bumper_sensors})
    :timer.send_interval(200, :dj, {:check_on, @battery_sensors})

    dj_opts = Keyword.put(dj_opts, :report_to, publisher_pid)
    children = [
      worker(Roombex.DJ, [dj_opts, [name: :dj]]),
      worker(Recruitbot.Pulsar, []),
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
    Map.take(sensors, @battery_sensors ++ @bumper_sensors)
  end
end
