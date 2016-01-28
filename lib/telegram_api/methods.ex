defmodule TelegramApi.Methods do

  @moduledoc """
  Message responses:
  https://core.telegram.org/bots/api#message

  Bot methods:
  https://core.telegram.org/bots/api#available-methods
  """

  defmacro __using__(_options) do
    quote do
      import TelegramApi.Methods
    end
  end

  defp api_url do
    url = "https://api.telegram.org/bot"
    url <> Application.get_env(:telegram_api, :api_key)
  end

  defp get_result(url) do
    response = HTTPotion.post api_url <> url
    Poison.Parser.parse!((response.body), keys: :atoms).result
  end

  def get_updates(offset) do
    results = "/getUpdates?offset=#{offset}"
              |> get_result

    if length(results) >= 1 do
      results
    else
      nil
    end
  end

  def get_me do
    "/getMe"
    |> get_result
  end

  def send_message(chat_id, text, parse_mode \\ "Markdown", disable_web_page_preview \\ false, reply_to_message_id \\ nil, reply_markup \\ nil) do
    "/sendMessage?chat_id=#{chat_id}&text=#{text}&parse_mode=#{parse_mode}&disable_web_page_preview=#{disable_web_page_preview}&reply_to_message_id=#{reply_to_message_id}&reply_markup=#{reply_markup}"
    |> get_result
  end

  def foward_message(chat_id, from_chat_id, message_id) do
    "/forwardMessage?chat_id=#{chat_id}&from_chat_id=#{from_chat_id}&message_id=#{message_id}"
    |> get_result
  end

  def send_photo(chat_id, photo, caption \\ nil, reply_to_message_id \\ nil, reply_markup \\ nil) do
    "/sendPhoto?chat_id=#{chat_id}&photo=#{photo}&caption=#{caption}&reply_to_message_id=#{reply_to_message_id}&reply_markup=#{reply_markup}"
    |> get_result
  end

  def send_audio(chat_id, audio, duration \\ nil, performer \\ nil, title \\ nil, reply_to_message_id \\ nil, reply_markup \\ nil) do
    "/sendAudio?chat_id=#{chat_id}&audio=#{audio}&duration=#{duration}&performer=#{performer}&title=#{title}&reply_to_message_id=#{reply_to_message_id}&reply_markup=#{reply_markup}"
    |> get_result
  end

  def send_document(chat_id, document, reply_to_message_id \\ nil, reply_markup \\ nil) do
    "/sendDocument?chat_id=#{chat_id}&document=#{document}&reply_to_message_id=#{reply_to_message_id}&reply_markup=#{reply_markup}"
    |> get_result
  end

  def send_sticker(chat_id, sticker, reply_to_message_id \\ nil, reply_markup \\ nil) do
    "/sendSticker?chat_id=#{chat_id}&sticker=#{sticker}&reply_to_message_id=#{reply_to_message_id}&reply_markup=#{reply_markup}"
    |> get_result
  end

  def send_video(chat_id, video, duration \\ nil, caption \\ nil, reply_to_message_id \\ nil, reply_markup \\ nil) do
    "/sendVideo?chat_id=#{chat_id}&video=#{video}&duration=#{duration}&caption=#{caption}&reply_to_message_id=#{reply_to_message_id}&reply_markup=#{reply_markup}"
    |> get_result
  end

  def send_location(chat_id, latitude, longitude, reply_to_message_id \\ nil, reply_markup \\ nil) do
    "/sendLocation?chat_id=#{chat_id}&latitude=#{latitude}&longitude=#{longitude}&reply_to_message_id=#{reply_to_message_id}&reply_markup=#{reply_markup}"
    |> get_result
  end

  def send_chat_action(chat_id, action) do
    "/sendChatAction?chat_id=#{chat_id}&action=#{action}"
    |> get_result
  end

  def get_user_profile_photos(user_id, offset \\ 0, limit \\ 100) do
    "/getUserProfilePhotos?user_id=#{user_id}&offset=#{offset}&limit=#{limit}"
    |> get_result
  end

  def get_file(file_id) do
    "/getFile?file_id=#{file_id}"
    |> get_result
  end
end
