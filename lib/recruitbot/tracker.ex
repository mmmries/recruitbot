defmodule Recruitbot.Tracker do
  use GenServer
  alias Roombex.{WhereAmI,DeadReckoner,DJ}
  alias Roombex.State.Sensors

  # Public Interface
  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def update(%Sensors{}=sensors) do
    GenServer.call(__MODULE__, {:update, sensors})
  end
  def reset(%Sensors{}=sensors) do
    GenServer.call(__MODULE__, {:reset, sensors})
  end

  # Server Callbacks
  def init(nil) do
    state = %{
      whereami: WhereAmI.init(DJ.sensors(:dj))
    }
    {:ok, state}
  end

  def handle_call({:update, %Sensors{}=sensors}, _from, %{whereami: whereami}=state) do
    whereami = DeadReckoner.update(whereami, sensors)
    {:reply, whereami, %{state | whereami: whereami}}
  end
  def handle_call({:reset, %Sensors{}=sensors}, _from, state) do
    whereami = WhereAmI.init(sensors)
    {:reply, whereami, %{state | whereami: whereami}}
  end
end
