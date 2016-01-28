defmodule TelegramApi.Module do
  alias TelegramApi.Methods

  defmacro __using__(_options) do
    quote do
      import TelegramApi.Module
    end
  end

  def urlize(text), do: String.split(text, "\n") |> Enum.join("%0A")

  defmacro command(text, do: func) do
    quote do
      def match_msg(%{text: "/" <> unquote(text)} = var!(msg)) do
        unquote(func)
      end
    end
  end

  defmacro regex(text, do: func) do
    quote do
      def match_msg(%{text: unquote(text)} = var!(msg)) do
        unquote(func)
      end
    end
  end

  defmacro reply(text) do
    quote do
      Methods.send_message(var!(msg).chat.id, urlize(unquote(text)))
    end
  end
end
