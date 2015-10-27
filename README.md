# MlbStats

Compiles a day's worth of mlb pitch data and returns the count and average speed grouped by pitch type

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add mlb_stats to your list of dependencies in `mix.exs`:

        def deps do
          [{:mlb_stats, "~> 0.0.1"}]
        end

  2. Ensure mlb_stats is started before your application:

        def application do
          [applications: [:mlb_stats]]
        end

## Usage

```
stats = MlbStats.PitchCollector.compile("2015", "06", "09") # year, month, day
=> [%{MlbStats.PitchCollector.PitchStats},%{MlbStats.PitchCollector.PitchStats},...]
```