defmodule Recruitbot.RoombaChannel do
  use Phoenix.Channel
  alias Roombex.DJ
  alias Recruitbot.Tracker

  def join("roomba", _auth, socket), do: {:ok, socket}

  def handle_in("drive", %{"velocity" => velocity, "radius" => radius}, socket) do
    DJ.command(:dj, Roombex.drive(velocity, radius))
    {:reply, {:ok, %{}}, socket}
  end
  def handle_in("position_reset", _params, socket) do
    sensors = DJ.sensors(:dj)
    Tracker.reset(sensors)
    send :publisher, {:roomba_status, sensors}
    {:reply, {:ok, %{}}, socket}
  end
  def handle_in("reset", %{}, socket) do
    DJ.reset(:dj)
    {:reply, {:ok, %{}}, socket}
  end
  def handle_in("safe", %{}, socket) do
    DJ.command(:dj, Roombex.safe)
    {:reply, {:ok, %{}}, socket}
  end
end
