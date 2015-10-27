defmodule PitchCollectorTest do
  use ExUnit.Case

  test "can compile stats" do
    stats = MlbStats.PitchCollector.compile("2015", "06", "09")

    assert Enum.count(stats) == 12
    assert Enum.all?(stats, &valid_stat/1)
  end

  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 419, name: "CH"}) do true end
  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 280, name: "CU"}) do true end
  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 246, name: "FC"}) do true end
  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 1679, name: "FF"}) do true end
  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 1, name: "FO"}) do true end
  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 98, name: "FS"}) do true end
  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 460, name: "FT"}) do true end
  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 16, name: "IN"}) do true end
  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 103, name: "KC"}) do true end
  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 1, name: "PO"}) do true end
  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 265, name: "SI"}) do true end
  defp valid_stat(%MlbStats.PitchCollector.PitchStats{count: 598, name: "SL"}) do true end
  defp valid_stat(_) do false end
end
