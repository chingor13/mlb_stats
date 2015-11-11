defmodule PitchStatsTest do
  use ExUnit.Case

  alias MlbStats.PitchCollector.PitchStats

  test "can combine dicts of PitchStats structs" do
    a = %{
      "A" => %PitchStats{name: "A", count: 12, average: 3.5},
      "B" => %PitchStats{name: "B", count: 30, average: 3.2}
    }
    b = %{
      "B" => %PitchStats{name: "B", count: 10, average: 2.4},
      "C" => %PitchStats{name: "C", count: 11, average: 12}
    }
    expected = %{
      "A" => %PitchStats{name: "A", count: 12, average: 3.5},
      "B" => %PitchStats{name: "B", count: 40, average: 3.0},
      "C" => %PitchStats{name: "C", count: 11, average: 12}
    }

    assert expected == PitchStats.merge(a, b)
  end

  test "can add two PitchStat structs" do
    a = %PitchStats{name: "B", count: 30, average: 3.2}
    b = %PitchStats{name: "B", count: 10, average: 2.4}

    assert %PitchStats{name: "B", count: 40, average: 3.0} == PitchStats.add(a, b)
  end

  test "can't add two PitchStats of different names" do
    a = %PitchStats{name: "A", count: 30, average: 3.2}
    b = %PitchStats{name: "B", count: 10, average: 2.4}

    assert_raise ArgumentError, "PitchStats of different types", fn ->
      PitchStats.add(a, b)
    end
  end

end
