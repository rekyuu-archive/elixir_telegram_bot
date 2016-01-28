defmodule TelegramBot.Module do
  defmacro __using__(_options) do
    quote do
      import TelegramBot.Module
    end
  end

  defmacro command(command_list, do: func) when is_list(command_list) do
    for text <- command_list do
      quote do
        def match_msg(%{text: "/" <> unquote(text) <> _} = var!(msg)) do
          unquote(func)
        end
      end
    end
  end

  defmacro command(text, do: func) do
    quote do
      def match_msg(%{text: "/" <> unquote(text) <> _} = var!(msg)) do
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
      Nadia.send_message(var!(msg).chat.id, unquote(text))
    end
  end
end
