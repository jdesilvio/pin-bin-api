use Mix.Config

# General application configuration
config :pin_bin,
  ecto_repos: [PinBin.Repo]

# Configures the endpoint
config :pin_bin, PinBinWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nyNU+drASfGWwGuD3gtT8l2jFWk5cr+gFScvkm6zVx1copuk1PuucLIFWZRBpJEw",
  render_errors: [view: PinBinWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PinBin.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: :all

# Guardian config
config :guardian, Guardian,
  issuer: "PinBin.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: PinBinWeb.GuardianSerializer,
  secret_key: to_string(Mix.env) <> "SuPerseCret_aBraCadabrA"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
