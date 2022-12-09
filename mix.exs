defmodule Exwhisper.MixProject do
  use Mix.Project

  def project do
    [
      app: :exwhisper,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Exwhisper.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:membrane_core, "~> 0.10.2"},
      {:membrane_file_plugin, "~> 0.12"},
      {:membrane_portaudio_plugin, "~> 0.13"},
      {:membrane_ffmpeg_swresample_plugin, "~> 0.14"},
      {:membrane_mp3_mad_plugin, "~> 0.13.0"},
      {:bumblebee, "~> 0.1.0"},
      {:nx, "~> 0.4.1"},
      {:exla, "~> 0.4.1"},
      {:axon, "~> 0.3.1"},
      {:req, "~> 0.3.3"}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
