defmodule MlbStats.PitchCollector do
  defmodule PitchStats do
    defstruct name: "", count: 0, average: 0.0

    @doc """
    Merge 2 dicts of pitch name => PitchStats and recalculate the count and
    average for pitches of the same type
    """
    def merge(dict1, dict2) do
      Dict.merge(dict1, dict2, fn(_k, pitch_stat1, pitch_stat2) ->
        PitchStats.add(pitch_stat1, pitch_stat2)
      end)
    end

    def add(%PitchStats{name: name1}, %PitchStats{name: name2}) when name1 != name2 do
      raise ArgumentError, message: "PitchStats of different types"
    end
    def add(pitch_stat1, pitch_stat2) do
      new_count = pitch_stat1.count + pitch_stat2.count
      new_average = (pitch_stat1.count * pitch_stat1.average + pitch_stat2.count * pitch_stat2.average)/new_count
      %PitchStats{pitch_stat1 | count: new_count, average: new_average}
    end
  end


  @doc """
  Compiles statistics for pitches for an entire year
  Returns a Dict of "name" => PitchCollector.PitchStats
  """
  def compile(year) do
    # not yet implemented
  end

  @doc """
  Compiles statistics for pitches for an entire month
  Returns a Dict of "name" => PitchCollector.PitchStats
  """
  def compile(year, month) do
    # not yet implemented
  end

  @doc """
  Compiles statistics for pitches for a single day
  Returns a Dict of "name" => PitchCollector.PitchStats
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
    dict
      |> Enum.map(&combine_pitches/1)
      |> Enum.reduce(%{}, fn (pitch_stat, acc) -> Map.put(acc, Map.get(pitch_stat, :name), pitch_stat) end)
  end

  defp combine_pitches({type, pitches}) do
    count = Enum.count(pitches)
    speeds = Enum.map(pitches, fn(pitch) -> pitch.speed end)
    average = Enum.sum(speeds) / count

    %PitchStats{name: type, count: count, average: average}
  end

  defp compile_game(game) do
    game.pitches
      |> Enum.group_by(fn(pitch) -> pitch.type end)
      |> compile_stats
  end

  defp reduce_stats(list_of_list_of_stats) do
    list_of_list_of_stats
      |> Enum.reduce
  end
end