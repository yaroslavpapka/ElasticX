defmodule ArticleApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ArticleAppWeb.Telemetry,
      ArticleApp.Repo,
      {DNSCluster, query: Application.get_env(:article_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ArticleApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ArticleApp.Finch},
      # Start a worker by calling: ArticleApp.Worker.start_link(arg)
      # {ArticleApp.Worker, arg},
      # Start to serve requests, typically the last entry
      ArticleAppWeb.Endpoint,
    ]
    ArticleApp.ElasticsearchCluster.get_cluster()
    ArticleApp.Elasticsearch.Index.create_index()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ArticleApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ArticleAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
