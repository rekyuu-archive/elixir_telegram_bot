defmodule TelegramBot.Commands do
  use TelegramBot.Module

  command "start", do: reply "Okay!"

  match _ do
    nil
  end
end
