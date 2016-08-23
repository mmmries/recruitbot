defmodule Recruitbot.DeadReckonerTest do
  use ExUnit.Case, async: true
  import Recruitbot.DeadReckoner

  test "moving forward" do
    whereami = Recruitbot.WhereAmI.init
      |> update(%{encoder_counts_left: 509, encoder_counts_right: 509})
    assert_in_delta whereami.x, 226.2, 0.1
    assert_in_delta whereami.y,   0.0, 0.1
  end
end
