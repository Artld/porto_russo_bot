require 'telegram/bot'

class BotConnector
  def initialize chat, text
    @chat = chat
    @text = text
    token = Rails.application.secrets.telegram_bot_token
    @api = ::Telegram::Bot::Api.new token
  end

  def send_message
    $logger.debug "message sending... #{@chat} ... #{@text}"
    @api.call('sendMessage', chat_id: @chat, text: @text)
  end
end
