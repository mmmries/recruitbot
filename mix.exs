defmodule Recruitbot.Mixfile do
  use Mix.Project

  def project do
    [app: :recruitbot,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Recruitbot, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext, :httpoison]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:gettext, "~> 0.9"},
      {:httpoison, "~> 0.8.0"},
      {:phoenix, "~> 1.1.0"},
      {:phoenix_html, "~> 2.3"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:roombex, "~> 0.0.5"},
    ]
  end
end
