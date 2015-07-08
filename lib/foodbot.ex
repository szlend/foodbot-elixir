defmodule Foodbot do
  def handle(_, nil),            do: {400, "Bad request"}
  def handle(restaurants, "all") do
    restaurants
    |> Dict.values
    |> Stream.map(&struct/1)
    |> Paratize.Pool.parallel_map(&fetch_restaurant_menu/1)
    |> Enum.join("\n")
    |> post_to_slack
  end

  def handle(restaurants, command) do
    case Dict.fetch(restaurants, String.to_atom(command)) do
      {:ok, restaurant} -> struct(restaurant) |> fetch_restaurant_menu |> post_to_slack
       :error           -> "Unknown command '#{command}'"
    end
  end

  defp fetch_restaurant_menu(restaurant) do
    restaurant
    |> Restaurant.menu
    |> format_menu(restaurant)
  end

  defp post_to_slack(text) do
    url = Application.get_env(:foodbot, :webhook_url)
    body = JSON.encode!([text: text])
    HTTPoison.post!(url, body)
    ""
  end

  defp format_menu({:error, message}, restaurant) do
    format_restaurant_title(restaurant)
    <> "\n"
    <> "  • #{message}"
  end

  defp format_menu(menu, restaurant) do
    menu_text = menu
    |> Stream.map(&format_menu_item/1)
    |> Enum.join("\n")

    format_restaurant_title(restaurant)
    <> "\n"
    <> menu_text
  end

  defp format_menu_item({name, price}), do: "  • #{normalize_name(name)} (#{price})"
  defp format_menu_item(name),          do: "  • #{normalize_name(name)}"

  defp format_restaurant_title(restaurant) do
    today = Chronos.Formatter.strftime(Chronos.today, "%A, %0d.%0m.%Y")
    "*#{restaurant.name} (#{today})*"
  end

  defp normalize_name(name) do
    name
    |> String.strip
    |> String.downcase
    |> String.replace(~r/\s+/, " ")
    |> String.replace(" ,", ",")
  end
end
