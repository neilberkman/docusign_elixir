defmodule DocuSign.MixProject do
  use Mix.Project

  def project do
    [
      app: :docusign,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:poison, "~> 3.0"},
      {:joken, "~> 1.5"},
      {:oauth2, "~> 0.9.3"}
    ]
  end
end
