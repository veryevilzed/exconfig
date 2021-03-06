defmodule Exconfig.Mixfile do
  use Mix.Project

  def project do
    [
     app: :exconfig,
     version: "0.0.1",
     deps: deps,
     config_files: [
        base: "contrib/base.toml"
     ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [ applications: [] ]
  end


  # List all dependencies in the format:
  #
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      { :etoml, github: "kalta/etoml"}
    ]
  end
end
