use Mix.Config

config :trot, router: Router
config :foodbot, restaurants: %{
  pauza:    Foodbot.Restaurant.Pauza,
  pizzapub: Foodbot.Restaurant.PizzaPub,
  wtc:      Foodbot.Restaurant.WTCMenza
}

import_config "#{Mix.env}.exs"
