defmodule TelegramApi.Parsing do
  use GenServer

  def start_link(opts \\ []) do
    require Logger

    Logger.log :info, "Starting parsing."
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def handle_cast({:parse, msg}, state) do
    match_msg(msg)
    {:noreply, state}
  end

  def match_msg(_), do: nil
end
