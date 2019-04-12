defmodule DocuSign.MixProject do
  @moduledoc false
  use Mix.Project

  @version "0.1.3"
  @url "https://github.com/TandemEquity/docusign_elixir"
  @maintainers [
    "Neil Berkman",
    "Pavel Herasimau"
  ]

  def project do
    [
      name: "DocuSign",
      app: :docusign,
      version: @version,
      elixir: "~> 1.7",
      package: package(),
      source_url: @url,
      maintainers: @maintainers,
      description: "Unofficial DocuSign Elixir Library used to interact with the eSign REST API.",
      homepage_url: @url,
      deps: deps(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :oauth2],
      mod: {DocuSign.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 4.0"},
      {:joken, "~> 2.0"},
      {:oauth2, "~> 1.0"},
      {:tesla, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},

      # test
      {:mock, "~> 0.3.2"},
      {:bypass, "~> 1.0"},

      # dev
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false}
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
