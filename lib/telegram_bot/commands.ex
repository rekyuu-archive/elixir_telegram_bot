defmodule TelegramBot.Commands do
  use TelegramBot.Module

  command "ping", do: reply "Pong!"

  command "say" do
    [_ | repeat] = String.split(msg.text)
    reply repeat |> Enum.join(" ")
  end

  match ["hello", "hi", "hey", "sup"] do
    case msg do
      %{from: %{username: name}}   -> reply "Hi there, @#{name}!"
      %{from: %{first_name: name}} -> reply "Hi there, #{name}!"
    end
  end
end
