defmodule BoringAvatar.MixProject do
  use Mix.Project

  def project do
    [
      app: :boring_avatar,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:color, "~> 0.12"}
    ]
  end
end
