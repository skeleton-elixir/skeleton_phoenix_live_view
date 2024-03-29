defmodule SkeletonPhoenixLiveView.MixProject do
  use Mix.Project

  @version "1.0.1"
  @source_url "https://github.com/skeleton-elixir/skeleton_phoenix_live_view"
  @maintainers [
    "Diego Nogueira",
    "Jhonathas Matos"
  ]

  def project do
    [
      name: "SkeletonPhoenixLiveView",
      app: :skeleton_phoenix_live_view,
      version: @version,
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      source_url: @source_url,
      description: description(),
      maintainers: @maintainers,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, ">= 0.17.0"},
      {:floki, ">= 0.34.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.6.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.15", only: :test}
    ]
  end

  defp description() do
    "O Skeleton Phoenix Live View é um facilitador para criação de live em sua aplicação,
    permitindo que você tenha os métodos enxutos e auto explicativos."
  end

  defp elixirc_paths(:test), do: ["lib", "test/app", "test/app_web"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      maintainers: @maintainers,
      licenses: ["MIT"],
      files: ~w(lib CHANGELOG.md LICENSE mix.exs README.md),
      links: %{
        "GitHub" => @source_url,
        "Changelog" => "#{@source_url}/blob/master/CHANGELOG.md"
      }
    ]
  end
end
