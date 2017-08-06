require './lib/http_request.rb'
require './lib/bot_connector.rb'

class TranslateJob < ApplicationJob
  queue_as :default

  def perform(chat, text, lang_string)
    url = "https://translate.google.com/\##{lang_string}/#{text}"
    resp = HttpRequest.get url
    BotConnector.new(chat, resp).send_message
  end
end
