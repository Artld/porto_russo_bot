require './lib/bot_dispatcher.rb'
require 'logger'

class WebhooksController < ApplicationController
  def callback
    BotDispatcher.new(chat, text, lang).process unless text.nil?
    render nothing: true, head: :ok
  end

  private

  def message
    params['message']
  end

  def text
    @text ||= message[:text] || message[:caption]
  end

  def from
    message[:from]
  end

  def lang
    code = from[:language_code]
    code = code.split('-').first if code.match /-/
    code
  end

  #def user
  #  from[:id]
  #end

  def chat
    message[:chat][:id]
  end
end
