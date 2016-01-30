defmodule TelegramBot do
  use Application
  use Supervisor

  tmp_dir = TelegramBot.Util.tmp_dir
  unless File.exists?(tmp_dir), do: File.mkdir(tmp_dir)

  def start(_type, _args) do
    require Logger
    Logger.log :info, "Starting bot supervisors."

    children = [
      supervisor(TelegramBot.Polling, [[name: TelegramBot.Polling]]),
      supervisor(TelegramBot.Parsing, [[name: TelegramBot.Parsing]])
    ]

    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)
  end
end
