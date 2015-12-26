defmodule Recruitbot.RoombaChannel do
  use Phoenix.Channel

  def join("roomba", _auth, socket), do: {:ok, socket}
end
