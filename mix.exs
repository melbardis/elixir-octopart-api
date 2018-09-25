defmodule OctopartApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :octopart_api,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Eric P Melbardis"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/melbardis/elixir-octopart-api"}
    ]
  end

  defp description do
    """
    An Elixir library that can be used to access the Octopart API.

    Note: to use this package, you will need a
    """
  end

  # the Octopart apikey should be configured in the user env under OCTOPART_APIKEY.
  defp apikey() do
    key = System.get_env("OCTOPART_APIKEY")

    if(key,
      do: key,
      else: "need to define OCTOPART_APIKEY in system environment"
    )
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {OctopartApi.Application, []},
      env: [octopart_url: "http://octopart.com/api/v3", apikey: apikey()]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      #  {:ecto, "~> 2.0"},
      #  {:postgrex, "~> 0.11"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 1.0"},
      #  {:json_api_client, "~> 3.0"},
      #  {:plug, "~> 1.0"},
      #  {:uri_query, "~> 0.1.1"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
