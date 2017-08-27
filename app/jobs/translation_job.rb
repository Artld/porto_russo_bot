require './lib/g_translation.rb'
require './lib/bot_connector.rb'

class TranslationJob < ApplicationJob
  queue_as :default

  def perform(chat, text, langs)
    resp = GTranslation.call text, langs[:from], langs[:to]
    # $logger.debug 'translation job got response'
    BotConnector.new(chat, resp).send_message
  end
end
