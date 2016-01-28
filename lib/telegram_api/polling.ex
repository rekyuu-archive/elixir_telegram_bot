defmodule TelegramApi.Polling do
  use GenServer

  def start_link(opts \\ []) do
    require Logger

    Logger.log :info, "Starting polling."
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def process_message(msg) do
    try do
      GenServer.cast(TelegramApi.Parsing, {:parse, msg})
    rescue
      e in MatchError -> Logger.log :warn, "[ERR] #{msg}"
    end
  end

  def process_messages_list(nil), do: -1
  def process_messages_list(results) do
    for item <- results, do: item.message |> process_message
    List.last(results).update_id
  end

  def init(:ok) do
    send self, {:update, 0}
    {:ok, []}
  end

  def handle_info({:update, id}, state) do
    new_id = id |> TelegramApi.Methods.get_updates |> process_messages_list

    :erlang.send_after(1000, self, {:update, new_id + 1})
    {:noreply, state}
  end
end
