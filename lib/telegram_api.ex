defmodule TelegramApi do
  use Application
  use Supervisor

  def start(_type, _args) do
    require Logger
    Logger.log :info, "Starting bot supervisors."

    children = [
      supervisor(TelegramApi.Polling, [[name: TelegramApi.Polling]]),
      supervisor(TelegramApi.Parsing, [[name: TelegramApi.Parsing]])
    ]

    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)
  end
end
