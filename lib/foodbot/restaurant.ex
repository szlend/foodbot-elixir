defmodule Foodbot.Restaurant do
  def process_url(url) do
    HTTPoison.get!(url).body
    |> Floki.parse
  end
end

defprotocol Restaurant do
  def menu(restaurant)
end
