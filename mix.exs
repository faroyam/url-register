defmodule UrlRegister.MixProject do
  use Mix.Project

  def project do
    [
      app: :url_register,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      deps: deps(),
      name: "UrlRegister",
      source_url: "https://github.com/faroyam/url-register"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {UrlRegister.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.1"},
      {:redix, "~> 0.10.2"},
      {:castore, "~> 0.1.4"},
      {:poison, "~> 4.0.1"},
      {:plug_logger_json, "~> 0.7.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "This application tracks URL visits and gathers the data to Redis."
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/faroyam/url-register"}
    ]
  end
end
