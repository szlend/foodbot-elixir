require IEx

defmodule Router do
  use Trot.Router
  use Trot.NotFound

  get "/" do
    restaurants = Application.get_env(:foodbot, :restaurants)
    command = fetch_query_params(conn).params["text"]
    Foodbot.handle(restaurants, command)
  end
end
