defmodule TelegramApi.Commands do
  use TelegramApi.Methods
  use TelegramApi.Wrappers

  command ["ping"], do: send_message(msg.chat.id, "pong")
end
