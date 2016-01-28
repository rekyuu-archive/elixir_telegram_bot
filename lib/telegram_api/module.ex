defmodule TelegramApi.Module do
  alias TelegramApi.Methods

  defmacro __using__(_options) do
    quote do
      use GenServer
      import TelegramApi.Module

      def start_link(opts \\ []) do
        GenServer.start_link(__MODULE__, :ok, opts)
      end

      defoverridable start_link: 1

      def init(:ok) do
        :pg2.join(:modules, self)
        Process.register(self, __MODULE__)
        {:ok, []}
      end

      defoverridable init: 1
    end
  end

  defmacro command(text, do: func) do
    quote do
      def match_msg(%{text: "/" <> unquote(text)} = var!(msg)) do
        unquote(func)
      end
    end
  end

  defmacro reply(text) do
    quote do
      Methods.send_message(var!(msg).chat.id, unquote(text))
    end
  end
end
