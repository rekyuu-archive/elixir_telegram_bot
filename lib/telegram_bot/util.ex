defmodule TelegramBot.Util do
  def tmp_dir, do: Application.app_dir(:telegram_bot) <> "/tmp"
end
