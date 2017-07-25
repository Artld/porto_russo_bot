Rails.application.routes.draw do
  post "/webhooks/telegram_#{Rails.application.secrets.webhook_token}" => 'webhooks#callback'
end
