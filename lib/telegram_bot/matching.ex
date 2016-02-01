defmodule TelegramBot.Matching do
  use GenServer
  import TelegramBot.Commands

  def start_link(opts \\ []) do
    require Logger

    Logger.log :info, "Starting parsing."
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def handle_cast({:match, msg}, state) do
    try do
      match_msg(msg)
    rescue
      _ -> nil
    end

    {:noreply, state}
  end
end
