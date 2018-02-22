source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.2'
gem 'rails', '~> 5.1.2'
gem 'puma', '~> 3.7'
gem 'telegram-bot-ruby', '~> 0.8.2'
gem 'google_drive', '~> 2.1.5'
gem 'rails-i18n', '~> 5.0.0'
gem 'json'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry-rails'
end
