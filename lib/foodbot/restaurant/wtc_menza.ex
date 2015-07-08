defmodule Foodbot.Restaurant.WTCMenza do
  defstruct name: "WTC Menza", url: "http://www.femec.si/poslovne-enote/"
end

defimpl Restaurant, for: Foodbot.Restaurant.WTCMenza do
  def menu(%{url: url}) do
    day = slovenian_weekday(Chronos.today)

    # get today's title and menu
    menu = Foodbot.Restaurant.process_url(url)
    |> Floki.find("##{day} .menucontent")

    # parse today's menu
    if menu do
      for menu_item <- menu do
        menu_item
        |> Floki.find("p")
        |> Stream.take(2)
        |> Stream.map(&Floki.text/1)
        |> Enum.join(", ")
      end
    else
      {:error, "No menu for today"}
    end
  end

  defp slovenian_weekday(date) do
    day = Chronos.Formatter.strftime(date, "%a")
    case day do
      "Mon" -> "ponedeljek"
      "Tue" -> "torek"
      "Wed" -> "sreda"
      "Thu" -> "cetrtek"
      "Fri" -> "friday"
      "Sat" -> "sobota"
      "Sun" -> "nedelja"
    end
  end
end
