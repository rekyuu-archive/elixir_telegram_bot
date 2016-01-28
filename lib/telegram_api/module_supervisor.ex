defmodule TelegramApi.ModuleSupervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    modules = [Application.get_env(:telegram_api, :modules)]

    children = for module <- modules do
      worker(module, [])
    end

    supervise(children, strategy: :one_for_one)
  end
end
