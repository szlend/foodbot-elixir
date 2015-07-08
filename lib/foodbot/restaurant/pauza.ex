defmodule Foodbot.Restaurant.Pauza do
  defstruct name: "Pauza", url: "http://www.pauza.si/"
end

defimpl Restaurant, for: Foodbot.Restaurant.Pauza do
  def menu(%{url: url}) do
    today = Chronos.Formatter.strftime(Chronos.today, "%0d.%0m.%Y")

    # get today's title and menu
    [title | menu] = Foodbot.Restaurant.process_url(url)
    |> Floki.find("article .content td")
    |> Enum.map(&Floki.text/1)

    # parse today's menu
    if String.contains? title, today do
      menu
      |> Stream.chunk(2)              # group cells by two
      |> Stream.map(&List.to_tuple/1) # group into tuple {item, price}
      |> Enum.filter(fn {_, p} -> String.ends_with?(p, "€") end) # filter pairs without a price
    else
      {:error, "No menu for today"}
    end
  end
end
