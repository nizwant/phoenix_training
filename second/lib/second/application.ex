defmodule Second.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SecondWeb.Telemetry,
      Second.Repo,
      {DNSCluster, query: Application.get_env(:second, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Second.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Second.Finch},
      # Start a worker by calling: Second.Worker.start_link(arg)
      # {Second.Worker, arg},
      # Start to serve requests, typically the last entry
      SecondWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Second.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SecondWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
