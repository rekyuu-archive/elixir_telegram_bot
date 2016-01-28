defmodule TelegramApi.Polling do
  use GenServer
  require Logger

  def start_link(opts \\ []) do
    Logger.log :debug, "Starting polling."
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def process_message(%{text: _} = msg), do: Logger.log :debug, "[MSG] #{msg.text}"
  def process_message(%{photo: _} = msg), do: Logger.log :debug, "[IMG] -----"
  def process_message(msg), do: Logger.log :debug, "[???] ?????"

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
