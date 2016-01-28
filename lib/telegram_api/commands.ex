defmodule TelegramApi.Commands do
  use TelegramApi.Module

  command "kuma", do: reply "Kuma ~"
  command "say" <> message, do: reply message
  command "help", do: reply "I'll put something here eventually."

  command "dank" do
    case msg do
      %{from: %{username: name}}   -> reply "Shut the fuck up, @" <> name
      %{from: %{first_name: name}} -> reply "Shut the fuck up, "  <> name
    end
  end

  command "s " <> search_term do
    url = String.split(search_term) |> Enum.join("%20")
    request = "https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{url}" |> HTTPoison.get!
    response = Poison.Parser.parse!((request.body), keys: :atoms)
    result = response.responseData.results |> List.first

    reply result.unescapedUrl
  end

  command "yt " <> search_term do
    url = String.split(search_term) |> Enum.join("%20")
    request = "https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=youtube%20#{url}" |> HTTPoison.get!
    response = Poison.Parser.parse!((request.body), keys: :atoms)
    result = response.responseData.results |> List.first

    reply result.unescapedUrl
  end

  regex "hi", do: reply "sup"
  regex "ty kuma", do: reply "np"
end
