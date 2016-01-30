defmodule TelegramBot.Commands do
  use TelegramBot.Module

  command "ping", do: reply "Pong!"

  match ["hello", "hi", "hey", "sup"] do
    case msg do
      %{from: %{username: name}}   -> reply "Hi there, @#{name}!"
      %{from: %{first_name: name}} -> reply "Hi there, #{name}!"
    end
  end
end
