use Mix.Config

# General application configuration
config :blaces,
  ecto_repos: [Blaces.Repo]

# Configures the endpoint
config :blaces, Blaces.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nyNU+drASfGWwGuD3gtT8l2jFWk5cr+gFScvkm6zVx1copuk1PuucLIFWZRBpJEw",
  render_errors: [view: Blaces.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Blaces.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Guardian config
config :guardian, Guardian,
 issuer: "Blaces.#{Mix.env}",
 ttl: {30, :days},
 verify_issuer: true,
 serializer: Blaces.GuardianSerializer,
 secret_key: to_string(Mix.env) <> "SuPerseCret_aBraCadabrA"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
