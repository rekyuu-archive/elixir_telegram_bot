defmodule TelegramBot.Migrations.InitDatabase do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username,  :string
      add :user_id,   :integer
      add :words,     {:array, :string}
      add :mute,      :boolean
    end

    create table(:chats) do
      add :chat_id, :string
      add :users,   {:array, :integer}
    end

    create unique_index(:chats, [:chat_id])
    create unique_index(:users, [:username])
  end
end
