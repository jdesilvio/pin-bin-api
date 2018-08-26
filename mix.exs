defmodule PinBin.Mixfile do
  use Mix.Project

  def project do
    [app: :pin_bin,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test,
                         "coveralls.detail": :test,
                         "coveralls.post": :test,
                         "coveralls.html": :test]]
  end

  def application do
    [mod: {PinBin, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html,
                    :cowboy, :logger, :gettext, :phoenix_ecto,
                    :postgrex, :yelp_ex, :comeonin, :ex_machina]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.3.4"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 3.3"},
      {:postgrex, "~> 0.13"},
      {:phoenix_html, "~> 2.12"},
      {:phoenix_live_reload, "~> 1.1", only: :dev},
      {:gettext, "~> 0.15"},
      {:cowboy, "~> 1.0"},

      # Other deps
      {:yelp_ex, "~> 0.2.1"},
      {:poison, "~> 3.0"},
      {:comeonin, "~> 3.0"},
      {:guardian, "~> 0.14"},
      {:excoveralls, "~> 0.6", only: :test},
      {:ex_machina, "~> 2.0"},
      {:corsica, "~> 1.1"}
    ]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
