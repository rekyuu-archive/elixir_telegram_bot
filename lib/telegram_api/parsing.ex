defmodule TelegramApi.Parsing do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    Logger.log :info, "Starting parsing."
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def handle_cast({:parse, msg}, state) do
    Logger.log :debug, "[MSG] #{msg.text}"
    {:noreply, state}
  end
end
