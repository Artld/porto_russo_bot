class BotDispatcher
  def initialize(chat, text, lang)
    @chat, @text, @lang = chat, text, lang
    I18n.locale = Set.new(['pt', 'ru']).include?(@lang) ? @lang : 'en'
  end

  def process
    case @text
    when /\A\/((start)|(stop)|(commands))\z/i
      reply I18n.t @text[1..-1]
    when /\/t\b/, /\/traduzir/i, /\/translate/i
      @text.slice! $& # removing last matching text from string
      translate auto_detect_language
    when /\/(#{$SUPPORTED_LANGUAGES})\b/
      @text.slice! $&
      translate({ from: '', to: $&[1..-1] })
    else
      translate auto_detect_language if @chat > 0
    end
  end

  private

  def translate(languages)
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
    { from: lang_1, to: lang_2 }
  end

  def reply(txt)
    BotConnector.new(@chat, txt).send_message
  end
end