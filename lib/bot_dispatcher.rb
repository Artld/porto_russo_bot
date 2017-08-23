require './lib/bot_connector.rb'

class BotDispatcher
  def initialize(chat, text, lang)
    @chat, @text, @lang = chat, text, lang
  end

  def process
    if @text =~ /\/start/i
      reply 'I love you! Send me portuguese or russian text and I\'ll translate it!'
    elsif @text =~ /\/stop/i
      reply 'Goodbye!'
    else
      translate
    end
  end

  private

  def translate
    TranslationJob.perform_later @chat, @text, languages
  end

  # Language auto detection
  def languages
    if @text =~ /[а-я]+/ui
      lang_1, lang_2 = 'ru', 'pt'
    elsif @text =~ /[a-z]+/i
      lang_1, lang_2 = 'pt', 'ru'
    else
      lang_1, lang_2 = 'auto', 'en'
    end
    {from: lang_1, to: lang_2}
  end

  def reply txt
    BotConnector.new(@chat, txt).send_message
  end
end
