defmodule Foodbot.Restaurant.PizzaPub do
  defstruct name: "Pizza Pub", url: "http://pizzapub.si/"
end

defimpl Restaurant, for: Foodbot.Restaurant.PizzaPub do
  def menu(%{url: url}) do
    today = Chronos.Formatter.strftime(Chronos.today, "%0d.%0m. %Y")

    # get today's menu
    menu = Foodbot.Restaurant.process_url(url)
    |> Floki.find("#main-slider") # get menus container
    |> elem(2)                    # get div children
    |> Enum.find(&String.contains?(Floki.text(&1), today)) # find div containing today's menu

    # parse today's menu
    if menu do
      menu
      |> Floki.find("h6")           # get menu text tag
      |> Stream.map(&Floki.text/1)  # get menu text
      |> Stream.map(&(Regex.run(~r/(.+)-([0-9]+,[0-9]+€)/, &1))) # match name and price
      |> Stream.reject(&is_nil/1)   # skip unmatched lines
      |> Enum.map(fn [_, name, price] -> {name, price} end) # map to tuple {name, price}
    else
      {:error, "No menu for today"}
    end
  end
end
