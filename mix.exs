defmodule DocuSign.MixProject do
  @moduledoc false
  use Mix.Project

  @version "3.0.0"
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
      docs: docs(),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore.exs",
        plt_add_apps: [:mix]
      ]
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
      {:req, "~> 0.5"},
      {:jason, "~> 1.4.4"},
      {:joken, "~> 2.0"},
      {:oauth2, "~> 2.0"},
      {:castore, "~> 1.0.15"},
      {:finch, "~> 0.20"},
      {:temp, "~> 0.4.9"},
      {:plug, "~> 1.18.1"},
      {:meck, "~> 0.9.2"},
      {:cowlib, "2.15.0"},

      # test
      {:mock, "~> 0.3.2", only: :test},
      {:bypass, "~> 2.1", only: :test},
      {:mox, "~> 1.0", only: :test},
      {:briefly, "~> 0.5", only: :test},

      # dev
      {:ex_doc, "~> 0.38.3", only: :dev},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4.6", only: [:dev], runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:quokka, "~> 2.11.2", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      extras: [
        "README.md",
        "CHANGELOG.md",
        "MIGRATING.md",
        "examples/embedded_signing.livemd",
        "examples/oauth_authorization_code_flow.livemd"
      ],
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @url,
      extra_section: "GUIDES",
      groups_for_extras: [
        Guides: ~r/examples\/.*/,
        "Migration Guides": ~r/MIGRATING\.md/,
        Changelog: ~r/CHANGELOG\.md/
      ],
      groups_for_modules: [
        API: ~r/DocuSign\.Api\..*/,
        Models: ~r/DocuSign\.Model\..*/,
        Core: ~r/DocuSign\.(Connection|ClientRegistry|OAuth|User|Util).*/,
        WebHook: ~r/DocuSign\.Webhook.*/
      ]
    ]
  end

  defp package do
    [
      maintainers: @maintainers,
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/docusign/changelog.html",
        "GitHub" => @url
      },
      files:
        ~w(lib) ++
          ~w(LICENSE mix.exs README.md CHANGELOG.md MIGRATING.md examples/embedded_signing.livemd examples/oauth_authorization_code_flow.livemd)
    ]
  end
end
