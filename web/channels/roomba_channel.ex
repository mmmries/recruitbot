defmodule Recruitbot.RoombaChannel do
  use Phoenix.Channel

  def join("roomba", _auth, socket), do: {:ok, socket}

  def handle_in("drive", %{"velocity" => velocity, "radius" => radius}) do
    send :dj, {:command, Roomba.drive(velocity, radius)}
  end
end
