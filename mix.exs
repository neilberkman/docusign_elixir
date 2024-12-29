defmodule DocuSign.MixProject do
  @moduledoc false
  use Mix.Project

  @version "1.2.0"
  @url "https://github.com/neilberkman/docusign_elixir"
  @maintainers [
    "Neil Berkman"
  ]

  def project do
    [
      name: "DocuSign",
      app: :docusign,
      version: @version,
      elixir: "~> 1.16 or ~> 1.17 or ~> 1.18",
      package: package(),
      source_url: @url,
      maintainers: @maintainers,
      description: "Unofficial DocuSign Elixir Library used to interact with the eSign REST API.",
      homepage_url: @url,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      docs: docs()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DocuSign.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:poison, "~> 6.0"},
      {:joken, "~> 2.0"},
      {:oauth2, "~> 2.0"},
      {:plug_cowboy, "~> 2.0"},
      {:castore, "~> 1.0"},
      {:mint, "~> 1.0"},

      # test
      {:mock, "~> 0.3.2", only: :test},
      {:bypass, "~> 2.1", only: :test},
      {:mox, "~> 1.0", only: :test},

      # dev
      {:ex_doc, "~> 0.28", only: :dev},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @url
    ]
  end

  defp package do
    [
      maintainers: @maintainers,
      licenses: ["MIT"],
      links: %{github: @url},
      files: ~w(lib) ++ ~w(LICENSE mix.exs README.md)
    ]
  end
end
