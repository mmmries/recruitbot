defmodule Recruitbot.DJSupervisor do
  use Supervisor
  require Logger
  alias Recruitbot.{Pulsar,Tracker,Whisker}
  alias Roombex.{DJ,WhereAmI}

  @sensors_to_publish [
    :battery_capacity,
    :battery_charge,
    :bumper_left,
    :bumper_right,
    :light_bumper_left,
    :light_bumper_left_front,
    :light_bumper_left_center,
    :light_bumper_right_center,
    :light_bumper_right_front,
    :light_bumper_right,
  ]

  def start_link(dj_opts) do
    Supervisor.start_link(__MODULE__, dj_opts, name: __MODULE__)
  end

  def init(dj_opts) do
    publisher_pid = spawn_link(&publish_roomba_updates/0)
    Process.register(publisher_pid, :publisher)

    dj_opts = Keyword.put(dj_opts, :report_to, publisher_pid)
    children = [
      worker(DJ, [dj_opts, [name: :dj]]),
      worker(Pulsar, []),
      worker(Tracker, []),
      worker(Whisker, []),
    ]
    supervise(children, strategy: :one_for_all)
  end

  defp publish_roomba_updates do
    receive do
      {:roomba_status, roombex_sensors} ->
        Recruitbot.Endpoint.broadcast("roomba", "sensor_update", sensors_to_map(roombex_sensors))
        whereami = Tracker.update(roombex_sensors)
        Recruitbot.Endpoint.broadcast("roomba", "position_update", whereami_to_map(whereami))
      msg -> Logger.error("#{__MODULE__} Received unexpected message #{inspect msg}")
    end
    publish_roomba_updates
  end

  defp sensors_to_map(sensors) do
    Map.take(sensors, @sensors_to_publish)
  end

  defp whereami_to_map(%WhereAmI{x: x, y: y, heading: heading}) do
    %{x: x, y: y, heading: heading}
  end
end
