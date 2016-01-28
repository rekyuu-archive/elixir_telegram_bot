defmodule TelegramApi.Wrappers do
  defmacro __using__(_options) do
    quote do
      import TelegramApi.Wrappers
    end
  end
end
