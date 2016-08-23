defmodule Recruitbot.DeadReckoner do
  alias Recruitbot.WhereAmI
  @axle_length 235.0

    # lovingly borrowed from http://www.seattlerobotics.org/encoder/200010/dead_reckoning_article.html
  def update(%WhereAmI{}=whereami, %{encoder_counts_left: count, encoder_counts_right: count}) do
    distance = encoder_counts_to_distance(count)
    x_delta = distance * :math.cos(whereami.heading)
    y_delta = distance * :math.sin(whereami.heading)
    %{whereami | x: whereami.x + x_delta, y: whereami.y + y_delta}
  end

  def update(%WhereAmI{}=whereami, %{encoder_counts_left: left, encoder_counts_right: right}) do
    cos_current = :math.cos(whereami.heading)
    sin_current = :math.sin(whereami.heading)
    dist_left = encoder_counts_to_distance(left)
    dist_right = encoder_counts_to_distance(right)
    right_minus_left = dist_right - dist_left
    expr1 = @axle_length * (dist_right + dist_left) / 2.0 / (right_minus_left)
    x_delta = expr1 * (:math.sin(right_minus_left / @axle_length + whereami.heading) - sin_current)
    y_delta = -1 * expr1 * (:math.cos(right_minus_left / @axle_length + whereami.heading) - cos_current)
    heading_delta = right_minus_left / @axle_length;

    %WhereAmI{
      x: whereami.x + x_delta,
      y: whereami.y + y_delta,
      heading: clamp_heading(whereami.heading + heading_delta),
      encoder_counts_left: left,
      encoder_counts_right: right,
    }
  end

  defp clamp_heading(heading) do
    cond do
      heading < -1 * :math.pi ->
        heading + (2 * :math.pi)
      heading > :math.pi ->
        heading - (2 * :math.pi)
      true ->
        heading
    end
  end

  defp encoder_counts_to_distance(count) do
    count * :math.pi * 72.0 / 508.8
  end
end
