defmodule Foodbot.Mixfile do
  use Mix.Project

  def project do
    [app: :foodbot,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    case Mix.env do
      :prod -> [applications: [:logger, :httpoison, :trot]]
      _     -> [applications: [:logger, :exsync, :httpoison, :trot]]
    end
  end

  defp deps do
    [{:trot, github: "hexedpackets/trot"},      # micro http framework
     {:httpoison, "~> 0.7"},                    # http client
     {:floki, "~> 0.3"},                        # html parser
     {:chronos, github: "nurugger07/chronos"},  # datetime lib
     {:paratize, "~> 2.0.0"},                   # parallel processing
     {:json, "~> 0.3.0"},                       # json support
     {:exsync, only: :dev}]                     # code reloader
  end
end
