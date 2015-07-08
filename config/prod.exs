use Mix.Config

config :trot, port: System.get_env("PORT")
config :foodbot, webhook_url: System.get_env("WEBHOOK_URL")
