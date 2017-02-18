# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
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

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
