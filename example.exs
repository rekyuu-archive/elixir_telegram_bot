defmodule TelegramApi.Commands do
  use TelegramApi.Module

  command "kuma", do: reply "Kuma ~"
end
