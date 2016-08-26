defmodule Recruitbot.Tracker do
  use GenServer
  alias Roombex.{WhereAmI,DeadReckoner,DJ,State}

  # Public Interface
  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def update(%State{}=sensors) do
    GenServer.call(__MODULE__, {:update, sensors})
  end
  def reset(%State{}=sensors) do
    GenServer.call(__MODULE__, {:reset, sensors})
  end

  # Server Callbacks
  def init(nil) do
    state = %{
      whereami: WhereAmI.init(DJ.sensors(:pid))
    }
    {:ok, state}
  end

  def handle_call({:update, %State{}=sensors}, _from, %{whereami: whereami}=state) do
    whereami = DeadReckoner.update(whereami, sensors)
    {:reply, whereami, %{state | whereami: whereami}}
  end
  def handle_call({:reset, %State{}=sensors}, _from, state) do
    whereami = WhereAmI.init(sensors)
    {:reply, whereami, %{state | whereami: whereami}}
  end
end
