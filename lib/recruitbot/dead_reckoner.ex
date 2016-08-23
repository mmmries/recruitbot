defmodule Recruitbot.DeadReckoner do
  alias Recruitbot.WhereAmI

  def update(%WhereAmI{}=whereami, %{encoder_counts_left: left, encoder_counts_right: right}) do
    distance = left * :math.pi * 72.0 / 508.8
    %{whereami | x: distance}
  end
end
