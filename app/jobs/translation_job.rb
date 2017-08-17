# require './lib/http_request.rb'
require './lib/g_translation.rb'
require './lib/bot_connector.rb'

class TranslationJob < ApplicationJob
  queue_as :default

  def perform(chat, text, langs)
    #url = "https://translate.google.com/\##{lang_string}/#{text}"
    #resp = HttpRequest.get url
    resp = GTranslation.call text, langs[:from], langs[:to]
    $logger.debug 'translation job got response'
    BotConnector.new(chat, resp).send_message
  end
end
