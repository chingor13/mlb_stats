defmodule PitchCollectorTest do
  use ExUnit.Case

  @tag :external
  test "can compile stats" do
    stats = MlbStats.PitchCollector.compile("2015", "06", "09")

    assert Enum.count(stats) == 12

    assert 419 == stats["CH"].count
    assert 280 == stats["CU"].count
    assert 246 == stats["FC"].count
    assert 1679 == stats["FF"].count
    assert 1 == stats["FO"].count
    assert 98 == stats["FS"].count
    assert 460 == stats["FT"].count
    assert 16 == stats["IN"].count
    assert 103 == stats["KC"].count
    assert 1 == stats["PO"].count
    assert 265 == stats["SI"].count
    assert 598 == stats["SL"].count
  end

end
