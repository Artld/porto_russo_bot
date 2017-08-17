require './lib/bot_connector.rb'

class BotDispatcher
  def initialize(chat, text, lang)
    @chat, @text, @lang = chat, text, lang
  end

  def process
    if @text =~ /\/[Ss]tart/
      reply 'I love you! Send me portuguese or russian text and I\'ll translate it!'
    elsif @text =~ /\/[Ss]top/
      reply 'Goodbye!'
    else
      translate
    end
  end

  private

  def translate
    TranslationJob.perform_later @chat, @text, languages
  end

  def languages
    lang = @lang.split('-').first
    if lang =~ /pt/
      lang_1, lang_2 = 'pt', 'ru'
    elsif lang =~ /ru/
      lang_1, lang_2 = 'ru', 'pt'
    else
      lang_1, lang_2 = 'auto', 'zh-CN'
    end
    {from: lang_1, to: lang_2}
  end

  def reply txt
    BotConnector.new(@chat, txt).send_message
  end
end
