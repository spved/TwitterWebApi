# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :twitterPheonix,
  ecto_repos: [TwitterPheonix.Repo]

# Configures the endpoint
config :twitterPheonix, TwitterPheonixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rB/7kiNhNgaa+Ia+AsgZapcFG20fLo7uzdANy2gDEJfWWqrRN7OWHpz47+MH3Vdl",
  render_errors: [view: TwitterPheonixWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TwitterPheonix.PubSub, adapter: Phoenix.PubSub.PG2]

# Configure DataBase


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :twitterPheonix, ecto_repos: [Engine.Repo]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
