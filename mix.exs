defmodule DocuSign.MixProject do
  use Mix.Project

  def project do
    [
      app: :docusign,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      package: package(),
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
      {:oauth2, "~> 0.9.3"},
      {:tesla, "~> 1.1"},

      # test
      {:mock, "~> 0.3.2"},
      {:bypass, "~> 0.8.1"},

      # dev
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Neil Berkman", "Pavel Herasimau"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/TandemEquity/docusign_elixir"
      }
    ]
  end
end
