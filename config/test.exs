import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :article_app, ArticleApp.Repo,
  username: System.get_env("DB_USERNAME") || "myuser",
  password: System.get_env("DB_PASSWORD") || "mypassword",
  hostname: System.get_env("DB_HOST") || "localhost",
  database: System.get_env("DB_NAME_TEST") || "mydatabase_test",
  port: String.to_integer(System.get_env("DB_PORT") || "5433"),
  pool: Ecto.Adapters.SQL.Sandbox,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true

config :article_app, ArticleApp.ElasticsearchCluster,
  url: System.get_env("ELASTICSEARCH_URL") || "http://localhost:9200",
  json_library: Jason,
  api: Elasticsearch.API.HTTP


# We don't run a server during test. If one is required,
# you can enable the server option below.
config :article_app, ArticleAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "xuzO4EJ1WYSP509KHMJETdKeXjhs9bl6heCtNgr18g9Me2YvGr9Zr1+tM2P8O5qF",
  server: false

# In test we don't send emails.
config :article_app, ArticleApp.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
