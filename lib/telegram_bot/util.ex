defmodule TelegramBot.Util do
  import Ecto.Query

  alias TelegramBot.Repo
  alias TelegramBot.Schema.User
  alias TelegramBot.Schema.Chat

  def create_user(username, user_id) do
    changeset = User.changeset(%User{}, %{username: username, user_id: user_id, words: [], mute: false})

    case Repo.insert(changeset) do
      {:ok, _} -> "Welcome, @" <> username <> "!\n\nYou can now add words to your watch list using /add. Be sure to /enable me in a group chat!"
      {:error, _} -> "No need to start me again!\n\nYou can add words to your watch list using /add, separated by spaces. Be sure to /enable me in a group chat!"
    end
  end

  def remove_user(username) do
    user = Repo.get_by(User, username: username)

    case Repo.delete(user) do
      {:ok, _} -> "Okay, @" <> username <> ", you're removed from the database. If you want, you can /start me again!"
      {:error, _} -> "Your username is not in the database! You can /start me if you'd like."
    end
  end

  def add_words(username, words) do
    user = Repo.get_by(User, username: username)
    words = Enum.uniq(user.words ++ words)
    changeset = Ecto.Changeset.change user, words: words

    case Repo.update(changeset) do
      {:ok, _} -> "Added! Type /list to show your active words."
      {:error, _} -> "There was an error! Let @rekyuu know!"
    end
  end

  def remove_words(username, words) do
    user = Repo.get_by(User, username: username)
    words = Enum.uniq(user.words -- words)
    changeset = Ecto.Changeset.change user, words: words

    case Repo.update(changeset) do
      {:ok, _} -> "Removed! Type /list to show your active words."
      {:error, _} -> "There was an error! Let @rekyuu know!"
    end
  end

  def list_words(username) do
    user = Repo.get_by(User, username: username)

    case user.words do
      [] -> "You don't have anything in your list."
      _  -> "Your active words: #{Enum.join(user.words, ", ")}"
    end
  end

  def enable_chat(username, chat_id) do
    user = Repo.get_by(User, username: username)
    chat = Repo.get_by(Chat, chat_id: chat_id)

    case chat do
      nil ->
        changeset = Chat.changeset(%Chat{}, %{chat_id: chat_id, users: [user.id]})

        case Repo.insert(changeset) do
          {:ok, _} -> "Enabled this chat for @#{user.username}!"
          {:error, _} -> "Eh? What are you saying? Let @rekyuu know."
        end
      chat ->
        case Enum.member?(chat.users, user.id) do
          false ->
            users = Enum.uniq(chat.users ++ [user.id])
            changeset = Ecto.Changeset.change chat, users: users

            case Repo.update(changeset) do
              {:ok, _} -> "Enabled this chat for @#{user.username}!"
              {:error, _} -> "I don't even know anymore. Let @rekyuu know I guess."
            end
          true -> "This chat is already enabled for @#{user.username}!"
        end
    end
  end

  def disable_chat(username, chat_id) do
    user = Repo.get_by(User, username: username)
    chat = Repo.get_by(Chat, chat_id: chat_id)

    case chat do
      nil -> "This chat hasn't been enabled..."
      chat ->
        case Enum.member?(chat.users, user.id) do
          true ->
            users = Enum.uniq(chat.users -- [user.id])
            changeset = Ecto.Changeset.change chat, users: users

            case Repo.update(changeset) do
              {:ok, _} -> "Disabled this chat for @#{user.username}."
              {:error, _} -> "Ha! No. Talk to @rekyuu instead."
            end
          false -> "This chat is already disabled for @#{user.username}."
        end
    end
  end

  def mute(username) do
    user = Repo.get_by(User, username: username)

    case user.mute do
      true -> "You're already muted."
      false ->
        changeset = Ecto.Changeset.change user, mute: true

        case Repo.update(changeset) do
          {:ok, _} -> "Muted notifications for @#{username}."
          {:error, _} -> "Gah! Let @rekyuu know!"
        end
    end
  end

  def unmute(username) do
    user = Repo.get_by(User, username: username)

    case user.mute do
      false -> "You're already unmuted."
      true ->
        changeset = Ecto.Changeset.change user, mute: false

        case Repo.update(changeset) do
          {:ok, _} -> "Unmuted notifications for @#{username}."
          {:error, _} -> "Gah! Let @rekyuu know!"
        end
    end
  end

  def launch_torpedoes(msg) do
    chat = Repo.get_by(Chat, chat_id: to_string(msg.chat.id))

    if chat != nil do
      chat.users
      |> Enum.map(fn user_id -> Repo.get_by(User, id: user_id) end)
      |> Enum.filter(fn user ->
        unless user == nil do
          msg.from.username != user.username
        end
      end)
      |> Enum.map(fn user -> match_message(user, msg) end)
    end
  end

  defp match_message(user, msg) do
    got_hit =
      msg.text
      |> String.split
      |> Enum.map(fn word -> match_word(word, user.words) end)
      |> Enum.any?

    if got_hit do
      Nadia.send_message(user.user_id, "From #{msg.chat.title}")
      Nadia.forward_message(user.user_id, to_string(msg.chat.id), msg.message_id)
    end
  end

  defp match_word(word, targets) do
    Enum.map(targets, fn target ->
      case Regex.compile("^#{target}$") do
        {:ok, re} -> Regex.match?(re, word)
        _ -> false
      end
    end)
    |> Enum.any?
  end
end
