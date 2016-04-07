defmodule TelegramBot.Schema.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    field :chat_id, :string
    field :users,   {:array, :integer}
  end

  def changeset(chat, params \\ :empty) do
    chat
    |> cast(params, ~w(chat_id users))
    |> unique_constraint(:chat_id)
  end
end
