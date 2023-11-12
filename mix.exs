defmodule GrpcReflection.MixProject do
  use Mix.Project

  def project do
    [
      app: :grpc_reflection,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [
        ignore_modules: [
          ~r/^Google\./,
          ~r/^Grpc\./,
          ~r/^Helloworld\./,
          GrpcReflection.TestEndpoint,
          GrpcReflection.TestEndpoint.ReflectionServer,
          GrpcReflection.TestEndpoint.ReflectionServer.Stub,
          GrpcReflection.TestEndpoint.Endpoint
        ]
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
      {:grpc, "~> 0.7"},
      {:protobuf, "~> 0.11"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      build_protos: [&build_protos/1]
    ]
  end

  defp build_protos(_argv) do
    options =
      Enum.join(
        [
          "gen_descriptors=true",
          "plugins=grpc",
          "include_docs=true"
        ],
        ","
      )

    Enum.each(
      [
        "priv/protos/grpc/reflection/v1alpha/reflection.proto",
        "priv/protos/grpc/reflection/v1/reflection.proto"
      ],
      fn reflection_proto ->
        Mix.shell().cmd(
          "protoc --elixir_out=#{options}:./lib/proto --proto_path=priv/protos/ #{reflection_proto}"
        )
      end
    )
  end
end
