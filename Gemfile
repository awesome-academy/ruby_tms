source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.1"

gem "bcrypt", "3.1.13"
gem "bootsnap", ">= 1.4.2", require: false
gem "bootstrap-sass", "3.4.1"
gem "bootstrap-will_paginate", "1.0.0"
gem "config"
gem "devise"
gem "faker", "1.7.3"
gem "figaro"
gem "i18n-js"
gem "jbuilder", "~> 2.7"
gem "mysql2", ">= 0.4.4"
gem "puma", "~> 4.1"
gem "rails", "~> 6.0.3", ">= 6.0.3.2"
gem "rails-controller-testing"
gem "rails-i18n"
gem "sass-rails", ">= 6"
gem "shoulda-matchers"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 4.0"
gem "will_paginate", "3.1.7"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :development, :test do
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
end

group :development, :test do
  gem "database_cleaner"
  gem "factory_bot_rails", require: false
  gem "rspec-rails", "~> 4.0.0"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
