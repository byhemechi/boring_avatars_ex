defmodule BoringAvatars.MixProject do
  use Mix.Project

  def project do
    [
      name: "Boring Avatars",
      app: :boring_avatars,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/byhemechi/boring_avatars_ex",
      docs: &docs/0,
      package: package(),
      description:
        "A direct port of boringdesigners/boring-avatars to elixir, with no dependencies"
    ]
  end

  defp docs do
    [
      main: "BoringAvatars",
      logo: "logo.svg",
      extras: ["README.md"]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [{:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true}]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/byhemechi/boring_avatars_ex"}
    ]
  end
end
