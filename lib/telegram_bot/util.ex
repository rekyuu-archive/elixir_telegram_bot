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
    words = String.split(msg.text)
    chat = Repo.get_by(Chat, chat_id: to_string(msg.chat.id))

    case chat do
      nil -> nil
      chat ->
        for user <- chat.users do
          user = Repo.get_by(User, id: user)

          unless msg.from.username == user.username do
            matches = for word <- user.words do
              case Enum.member?(words, word) do
                true -> {user.user_id, true}
                false ->
                  {:ok, re_word} = Regex.compile(word)
                  for msg_word <- words do
                    case Regex.match?(re_word, msg_word) do
                      true -> {user.user_id, true}
                      false -> {user.user_id, false}
                    end
                  end
              end
            end

            for match <- matches do
              case match do
                {_, false} -> nil
                {user_id, true} ->
                  Nadia.send_message(user_id, "From #{msg.chat.title}")
                  Nadia.forward_message(user_id, to_string(msg.chat.id), msg.message_id)
                match_list ->
                  for match <- match_list do
                    case match do
                      {_, false} -> nil
                      {user_id, true} ->
                        Nadia.send_message(user_id, "From #{msg.chat.title}")
                        Nadia.forward_message(user_id, to_string(msg.chat.id), msg.message_id)
                    end
                  end
              end
            end
          end
        end
    end
  end
end
