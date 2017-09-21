defmodule IwannaboxEx.Mixfile do
  use Mix.Project

  def project do
    [app: :iwannabox_ex,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger, :httpoison, :poison, :hackney, :phoenix_channel_client]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.13.0"},
      {:poison, "~> 2.0"},
      {:hackney, "~> 1.6"},
      {:phoenix_channel_client, github: "dparnell/phoenix_channel_client"}
    ]
  end
end
