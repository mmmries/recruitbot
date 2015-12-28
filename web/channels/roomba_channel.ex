defmodule Recruitbot.RoombaChannel do
  use Phoenix.Channel
  alias Roombex.DJ

  def join("roomba", _auth, socket), do: {:ok, socket}

  def handle_in("drive", %{"velocity" => velocity, "radius" => radius}, socket) do
    DJ.command(:dj, Roombex.drive(velocity, radius))
    {:reply, {:ok, %{}}, socket}
  end
end