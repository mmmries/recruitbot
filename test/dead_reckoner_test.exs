defmodule Recruitbot.DeadReckonerTest do
  use ExUnit.Case, async: true
  import Recruitbot.DeadReckoner
  alias Recruitbot.WhereAmI

  test "moving forward" do
    whereami = WhereAmI.init
      |> update(%{encoder_counts_left: 509, encoder_counts_right: 509})
    assert_in_delta whereami.heading, 0.0, 0.01
    assert_in_delta whereami.x,     226.2, 0.1
    assert_in_delta whereami.y,       0.0, 0.1
  end

  test "moving forward through a 90° turn to the right" do
    radius_left  = 1235.0
    radius_right = 1000.0
    distance_left_wheel  = (1/4) * 2 * :math.pi * radius_left
    distance_right_wheel = (1/4) * 2 * :math.pi * radius_right
    left = distance_to_encoder_counts(distance_left_wheel)
    right = distance_to_encoder_counts(distance_right_wheel)
    whereami = WhereAmI.init
    |> update(%{encoder_counts_left: left, encoder_counts_right: right})
    assert_in_delta whereami.heading, -0.5 * :math.pi, 0.01
    assert_in_delta whereami.x,                1117.5, 1.0
    assert_in_delta whereami.y,               -1117.5, 1.0
  end

  test "moving forward through a 90° turn to the left" do
    radius_left  = 1882.5
    radius_right = 2117.5
    distance_left_wheel  = (1/4) * 2 * :math.pi * radius_left
    distance_right_wheel = (1/4) * 2 * :math.pi * radius_right
    left = distance_to_encoder_counts(distance_left_wheel)
    right = distance_to_encoder_counts(distance_right_wheel)
    whereami = WhereAmI.init
    |> update(%{encoder_counts_left: left, encoder_counts_right: right})
    assert_in_delta whereami.heading,  0.5 * :math.pi, 0.01
    assert_in_delta whereami.x,                2000.0, 1.0
    assert_in_delta whereami.y,                2000.0, 1.0
  end

  defp distance_to_encoder_counts(distance_in_mm) do
    (distance_in_mm * 508.8 / :math.pi / 72.0)
    |> Float.ceil
    |> trunc
  end
end
