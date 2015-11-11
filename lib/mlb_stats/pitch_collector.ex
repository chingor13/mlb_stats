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
    ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
      |> queue_all(fn (month) -> compile(year, month) end)
      |> await_all
      |> merge
  end

  @doc """
  Compiles statistics for pitches for an entire month
  Returns a Dict of "name" => PitchCollector.PitchStats
  """
  def compile(year, month) do
    # FIXME - get the days of the month
    ["01", "02", "03"]
      |> queue_all(fn (day) -> compile(year, month, day) end)
      |> await_all
      |> merge
  end

  @doc """
  Compiles statistics for pitches for a single day
  Returns a Dict of "name" => PitchCollector.PitchStats
  """
  def compile(year, month, day) do
    Gameday.Game.list(year, month, day)
      |> ok([])
      |> queue_all(&compile_game/1)
      |> await_all
      |> merge
  end

  def compile_game(gid) do
    Gameday.Game.fetch(gid)
      |> ok
      |> Map.get(:pitches)
      |> Enum.group_by(&(Map.get(&1, :type)))
      |> compile_stats
  end

  defp queue_all(list, callback) do
    Enum.map(list, fn(param) -> Task.async(fn -> callback.(param) end) end)
  end

  defp await_all(list) do
    Enum.map(list, &Task.await/1)
  end

  defp merge(list_of_dicts) do
    Enum.reduce(list_of_dicts, %{}, fn(pitch_stat, acc) -> acc = MlbStats.PitchCollector.PitchStats.merge(acc, pitch_stat) end)
  end

  defp ok({:ok, resp}, _) do
    resp
  end
  defp ok(_, default \\ []) do
    default
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

end