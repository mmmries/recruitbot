defmodule Recruitbot.Checkin do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(nil) do
    :timer.send_interval(5_000, :checkin)
  end

  def handle_info(:checkin, state) do
    checkin_url = Application.get_env(:recruitbot, :checkin)
    |> Keyword.get(:url)

    case checkin_url do
      nil -> :no_op
      url -> HTTPoison.put(url, checkin_body, [{"content-type","application/json"}])
    end
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.error "received unpexected message #{inspect msg}"
    {:noreply, state}
  end

  defp checkin_body do
    {:ok, hostname} = :inet.gethostname()
    %{
      name: hostname,
      local_ip: local_ip(),
    } |> Poison.encode!
  end

  defp local_ip do
    all_local_ips()
    |> Enum.filter(fn({127,0,0,1}) -> false
                     (_) -> true end)
    |> Enum.sort
    |> List.first
    |> Tuple.to_list
    |> Enum.join(".")
  end

  defp all_local_ips do
    {:ok, ifs} = :inet.getif()
    Enum.map(ifs, fn({ip, _gateway, _broadcast}) -> ip end)
  end
end
