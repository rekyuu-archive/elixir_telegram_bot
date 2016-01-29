defmodule TelegramBot.Commands do
  use TelegramBot.Module

  command "kuma", do: reply "Kuma ~"

  command "say" do
    [_ | repeat] = String.split(msg.text)
    repeat |> Enum.join(" ") |> reply
  end

  command "help", do: reply "I'll put something\nhere eventually."

  command "dank" do
    case msg do
      %{from: %{username: name}}   -> reply "Shut the fuck up, @" <> name
      %{from: %{first_name: name}} -> reply "Shut the fuck up, "  <> name
    end
  end

  command ["s", "google", "find", "search"] do
    [_ | search_term] = String.split(msg.text)

    query = search_term |> Enum.join |> URI.encode_www_form
    request = "https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{query}" |> HTTPoison.get!
    response = Poison.Parser.parse!((request.body), keys: :atoms)
    result = response.responseData.results |> List.first

    reply result.unescapedUrl
  end

  command "yt" do
    [_ | search_term] = String.split(msg.text)

    query = search_term |> Enum.join |> URI.encode_www_form
    request = "https://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=youtube%20#{query}" |> HTTPoison.get!
    response = Poison.Parser.parse!((request.body), keys: :atoms)
    result = response.responseData.results |> List.first

    reply result.unescapedUrl
  end

  command ["dan", "danbooru"] do
    [_ | search_term] = String.split(msg.text)

    dan = "danbooru.donmai.us"
    query = search_term |> Enum.join("_") |> URI.encode_www_form
    request = "http://#{dan}/posts.json?limit=50&page=1&tags=#{query}+rating:safe" |> HTTPoison.get!

    try do
      result = Poison.Parser.parse!((request.body), keys: :atoms) |> Enum.random

      post_id = Integer.to_string(result.id)
      filename = "tmp/#{post_id}.#{result.file_ext}"
      image = "http://#{dan}#{result.file_url}" |> HTTPoison.get!

      File.write filename, image.body
      reply_photo_with_caption filename, "via https://#{dan}/posts/#{post_id}"
      File.rm filename
    rescue
      Enum.EmptyError -> reply "Nothing found!"
      _ -> reply "fsdafsd"
    end
  end

  regex "hi", do: reply "sup"
  regex "ty kuma", do: reply "np"
end
