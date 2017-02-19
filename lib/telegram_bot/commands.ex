defmodule TelegramBot.Commands do
  use TelegramBot.Module
  import TelegramBot.Util

  command "help" do
    reply_no_preview "I'm light cruiser Kitakami, nice ta meet 'ya.\n"
    <> "I'll notify you if someone says a specific word.\n"
    <> "Be sure to message me privately or you won't get any messages from me!\n"
    <> "\n"
    <> "/help - Lists commands.\n"
    <> "/start - Adds you for list creation.\n"
    <> "/add - Add a word to your notification list.\n"
    <> "/remove - Remove a word from your notification list.\n"
    <> "/list - List active words in your notification list.\n"
    <> "/enable - Enables notifications in current chat.\n"
    <> "/disable - Disables notifications in current chat (default).\n"
    <> "/mute - Mute all notifications.\n"
    <> "/unmute - Unmute all notifications.\n"
    <> "/stop - Removes you completely and stops notifications.\n"
    <> "\n"
    <> "Source (v1.1.1): https://github.com/rekyuu/elixir_telegram_bot/tree/kitakami"
  end

  command "start" do
    cond do
      Enum.member?(["group", "supergroup"], msg.chat.type) ->
        reply "Please /start me in a private message!"
      true ->
        reply create_user(msg.from.username, msg.from.id)
    end
  end

  command "stop",  do: reply remove_user(msg.from.username)

  command "add" do
    [_ | words] = String.split(msg.text)

    case words do
      nil -> reply "You didn't send anything to add..."
      words ->
        response = add_words(msg.from.username, words)
        reply response
    end
  end

  command "remove" do
    [_ | words] = String.split(msg.text)

    case words do
      nil -> reply "You didn't send anything to remove..."
      words ->
        response = remove_words(msg.from.username, words)
        reply response
    end
  end

  command "list", do: reply list_words(msg.from.username)

  command "enable" do
    case msg.chat.type do
      "group" -> reply enable_chat(msg.from.username, to_string(msg.chat.id), msg.chat.title)
      "supergroup" -> reply enable_chat(msg.from.username, to_string(msg.chat.id), msg.chat.title)
      _ -> reply "You can only do this in group chats."
    end
  end

  command "disable" do
    case msg.chat.type do
      "group" -> reply disable_chat(msg.from.username, to_string(msg.chat.id))
      "supergroup" -> reply disable_chat(msg.from.username, to_string(msg.chat.id))
      _ -> reply "You can only do this in group chats."
    end
  end

  command "mute", do: reply mute(msg.from.username)
  command "unmute", do: reply unmute(msg.from.username)

  command "info" do
    case msg.reply_to_message do
      nil -> "Please reply to a forwarded message for more information."
      fwd ->
        Nadia.send_message(msg.from.id, """
        Chat
        ```
        Title: #{fwd.chat.title}
        ID: #{fwd.chat.id}
        ```
        User
        ```
        Username: @#{fwd.forward_from.username}
        ID: #{fwd.forward_from.id}
        ```
        Date and Time
        ```
        Unix: #{fwd.date}
        ISO8601: #{DateTime.from_unix!(fwd.date) |> DateTime.to_iso8601}
        ```
        """, parse_mode: "Markdown")
    end
  end

  match _ do
    if Enum.member?(["group", "supergroup"], msg.chat.type) && msg.text, do: launch_torpedoes(msg)
  end
end
