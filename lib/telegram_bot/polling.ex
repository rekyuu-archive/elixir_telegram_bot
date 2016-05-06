defmodule TelegramBot.Polling do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    Logger.log :info, "Starting polling."
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def process_message(msg) do
    try do
      GenServer.cast(TelegramBot.Matching, {:match, msg})
    rescue
      e in MatchError -> Logger.log :warn, "[ERR] #{msg}, #{e}"
    end
  end

  def process_messages_list({:ok, []}), do: -1
  def process_messages_list({:ok, results}) do
    for item <- results, do: item.message |> process_message
    List.last(results).update_id
  end

  def process_messages_list({:error, error}) do
    case error do
      %Nadia.Model.Error{reason: _} -> Logger.log :warn, "Telegram timed out!"
      error ->                         Logger.log :error, error
    end

    -1
  end

  def init(:ok) do
    send self, {:update, 0}
    {:ok, []}
  end

  def handle_info({:update, id}, state) do
    new_id = Nadia.get_updates([offset: id]) |> process_messages_list

    :erlang.send_after(100, self, {:update, new_id + 1})
    {:noreply, state}
  end
end
