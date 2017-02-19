defmodule TelegramBot.Repo.Migrations.AddChatTitle do
  use Ecto.Migration

  def change do
    alter table(:chats) do
      add :title, :string
    end
  end
end
