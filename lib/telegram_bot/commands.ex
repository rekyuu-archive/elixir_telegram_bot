defmodule TelegramBot.Commands do
  use TelegramBot.Module

  command "ping", do: reply "Pong!"

  command ["s", "google", "find", "search"] do
    [_ | search_term] = String.split(msg.text)

    query = search_term |> Enum.join |> URI.encode_www_form
    request = "https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{query}" |> HTTPoison.get!
    response = Poison.Parser.parse!((request.body), keys: :atoms)
    result = response.responseData.results |> List.first

    reply result.unescapedUrl
  end

  match ["hello", "hi", "hey", "sup"] do
    case msg do
      %{from: %{username: name}}   -> reply "Hi there, @#{name}!"
      %{from: %{first_name: name}} -> reply "Hi there, #{name}!"
    end
  end
end
