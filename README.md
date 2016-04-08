# Kitakami

A bot that notifies users if specified words are said in group chats. Uses [Nadia](https://github.com/zhyu/nadia) to poll for updates and respond to them.

If you don't know much about Telegram bots, I suggest reading the [Telegram Bot API docs](https://core.telegram.org/bots/api).

## Installation

```
$ git clone https://github.com/rekyuu/elixir_telegram_bot
$ cd elixir_telegram_bot
$ mix deps.get
```

You will need to edit `config/config.exs` and add your bot's username:

```elixir
config :telegram_bot,
  username: "your_bot_name"
```

Then you need to create `config/secret.exs` with the following contents:

```elixir
use Mix.Config

config :nadia,
  token: "your-telegram-bot-api-key"
```

Then initiate the database:

```
$ mix ecto.create
$ mix ecto.migrate
```

Then run your bot using `iex -S mix`.

## Commands

Be sure to message Kitakami first or she won't be able to send you notifications.

```
/help     - Lists commands.
/start    - Adds you for list creation.
/add      - Add a word to your notification list.
/remove   - Remove a word from your notification list.
/list     - List active words in your notification list.
/enable   - Enables notifications in current chat.
/disable  - Disables notifications in current chat (default).
/mute     - Mute all notifications.
/unmute   - Unmute all notifications.
/stop     - Removes you completely and stops notifications.
```
