require './lib/bot_dispatcher.rb'
require 'logger'

class WebhooksController < ApplicationController
  # skip_before_action :verify_authenticity_token

  def callback
    BotDispatcher.new(chat, text, lang).process unless text.nil? # nil or false?
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
    from[:language_code]
  end

  #def user
  #  from[:id]
  #end

  def chat
    message[:chat][:id]
  end
end
