require './lib/bot_connector.rb'

class BotDispatcher
  def initialize(chat, text, lang)
    @chat, @text, @lang = chat, text, lang
    if Set.new(['pt', 'en', 'ru']).include? @lang
      I18n.locale = @lang
    else
      I18n.locale = 'en'
    end
  end

  def process
    case @text
    when /\/start/i
      reply I18n.t 'hello'
    when /\/stop/i
      reply I18n.t 'bye'
    when /\/commands/i
      reply I18n.t 'commands'
    when /\/t\b/, /\/translate/i
      @text.slice! $&  # removing last matching text from string
      translate auto_detect_language
    when /\/(#{$SUPPORTED_LANGUAGES})\b/
      @text.slice! $&
      translate({from: '', to: $&[1..-1]})
    else
      translate auto_detect_language if @chat > 0
    end
  end

  private

  def translate languages
    TranslationJob.perform_later @chat, @text, languages unless @text.empty?
  end

  def auto_detect_language
    if @text =~ /[а-я]+/ui
      lang_1, lang_2 = 'ru', 'pt'
    elsif @text =~ /[a-z]+/i
      lang_1, lang_2 = 'pt', 'ru'
    else
      lang_1, lang_2 = '', 'en'
    end
    {from: lang_1, to: lang_2}
  end

  def reply txt
    BotConnector.new(@chat, txt).send_message
  end
end
