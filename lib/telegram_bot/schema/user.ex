defmodule TelegramBot.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username,  :string
    field :user_id,   :integer
    field :words,     {:array, :string}
    field :mute,      :boolean
  end

  def changeset(user, params \\ :empty) do
    user
    |> cast(params, ~w(username), ~w(user_id words mute))
    |> unique_constraint(:username)
  end
end
