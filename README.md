You can try this bot in Telegram: @porto_russo_bot

To start application on your server you need your google configuration in
json format with "client_id", "client_secret" and "refresh_token" fields
required. See more:

https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md

To avoid storing my configuration file on github I used
config/g_drive_config.json file dynamically generated from G_CONFIG_VAR
environment variable.
