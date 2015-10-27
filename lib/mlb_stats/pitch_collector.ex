defmodule MlbStats.PitchCollector do
  defmodule PitchStats do
    defstruct name: "", count: 0, average: 0.0
  end

  @doc """
  Compiles statistics for pitches for a single day
  Returns an array of PitchCollector.PitchStats
  """
  def compile(year, month, day) do
    Gameday.Game.list(year, month, day)
      |> handle_games
      |> Enum.map(&queue_fetch/1) # fetch and parse each game id in a different process
      |> Enum.map(&Task.await/1) # wait for the results
      |> Enum.map(fn({:ok, game}) -> game.pitches end)
      |> List.flatten
      |> Enum.group_by(fn(pitch) -> pitch.type end)
      |> compile_stats
  end

  defp handle_games({:ok, gids}) do
    gids
  end
  defp handle_games(_) do
    []
  end

  defp queue_fetch(gid) do
    Task.async(fn -> Gameday.Game.fetch(gid) end)
  end

  defp compile_stats(dict) do
    Enum.map(dict, fn {type, pitches} ->
      count = Enum.count(pitches)
      speeds = Enum.map(pitches, fn(pitch) -> pitch.speed end)
      average = Enum.sum(speeds) / count

      %PitchStats{name: type, count: count, average: average}
    end)
  end
end