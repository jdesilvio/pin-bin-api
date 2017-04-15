use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blaces, Blaces.Endpoint,
  http: [port: System.get_env("PORT") || 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :blaces, Blaces.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "blaces_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
