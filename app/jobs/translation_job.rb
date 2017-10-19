class TranslationJob < ApplicationJob
  queue_as :default

  def perform(chat, text, langs)
    resp = GTranslation.call text, langs[:from], langs[:to]
    BotConnector.new(chat, resp).send_message
  end
end
