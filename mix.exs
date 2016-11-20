defmodule More.Mixfile do
  use Mix.Project

  def project do
    [app: :more,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    dev_apps = Mix.env == :dev && [:exsync] || []
    [applications: dev_apps ++ [:logger, :cowboy, :plug, :httpoison, :postgrex],
     mod: {More, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:cowboy, "~> 1.0.4"},
     {:plug, "~> 1.2"},
     {:expug, "~> 0.7"},
     {:poison, "~> 2.2"},
     {:httpoison, "~> 0.9"},
     {:postgrex, "~> 0.12"},
     {:ecto, "~> 2.0.5"},
     {:exsync, "~> 0.1", only: :dev}]
  end
end
