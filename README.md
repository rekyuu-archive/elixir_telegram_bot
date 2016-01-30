# Telegram Bot API for Elixir

A elixir app that uses Telegram methods from [Nadia](https://github.com/zhyu/nadia) to poll for updates and respond to them.

If you don't know much about Telegram bots, I suggest reading the [Telegram Bot API docs](https://core.telegram.org/bots/api).

## Installation

```
$ git clone https://github.com/rekyuu/ElixirTelegramBotAPI
$ cd ElixirTelegramBotAPI
$ mix deps.get
```

You now need to create `config/secret.exs` with the following contents:

```elixir
use Mix.Config

config :nadia,
  token: "your-telegram-bot-api-key"
```

Then run your bot using `iex -S mix`.

## Commands

You want to edit `lib/telegram_bot/commands.ex`. There are a couple of examples in there for you to go off of, but here they are explained:

```elixir
command "expression" do
```

`"expression"` would be the name of the command. IE, `/start` would appear as `command "start" do`. This can also be a list of commands that do the same thing, ex: `command ["hi", "hello"] do`.

```elixir
match "expression" do
```

This matches the message exactly. Be sure that your bot has privacy disabled with Botfather to see all user message or this won't work. This can also be parsed with a list of expressions.

```elixir
reply "text"
```

Does what it says, replies to the same chat that the message originated from. There are a couple others I've added:

```elixir
reply_no_preview "text"

reply_photo "/path/to/image.png"

reply_photo_with_caption "/path/to/image.png", "caption text"
```

## Message handling

Each of the above wrappers handle the incoming message as a [Nadia struct]() and is passed as the variable `msg`. The example given in `commands.ex` is as follows: 

```elixir
match ["hello", "hi", "hey", "sup"] do
  case msg do
    %{from: %{username: name}}   -> reply "Hi there, @#{name}!"
    %{from: %{first_name: name}} -> reply "Hi there, #{name}!"
  end
end
```
