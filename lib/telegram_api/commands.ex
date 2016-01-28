defmodule TelegramApi.Commands do
  use TelegramApi.Module

  command "kuma", do: reply "Kuma ~"
  command "say" <> message, do: reply message
  command "help", do: reply "I'll put something here eventually."

  command "dank" do
    case msg do
      %{from: %{username: name}}   -> reply "Shut the fuck up, @" <> name
      %{from: %{first_name: name}} -> reply "Shut the fuck up, "  <> name
    end
  end

  regex "hi", do: reply "sup"
  regex "ty kuma", do: reply "np"
end
