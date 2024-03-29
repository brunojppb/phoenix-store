# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :mango,
  ecto_repos: [Mango.Repo]

config :mango, MangoWeb.Gettext, default_locale: "en"

# Configures the endpoint
config :mango, MangoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/c1xmiMzTE52N1QkLpj9tw+yylRcheWV2GeuwPXSVm6XesWfie3mDGx1AwJ378vt",
  render_errors: [view: MangoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mango.PubSub,
  live_view: [signing_salt: "CSUNIpsv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
