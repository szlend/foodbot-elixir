use Mix.Config

config :trot, router: Router
config :foodbot, restaurants: %{
  pauza:    Foodbot.Restaurant.Pauza,
  pizzapub: Foodbot.Restaurant.PizzaPub
}

import_config "#{Mix.env}.exs"
