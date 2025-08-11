source "https://rubygems.org"

# Core
gem "rails", "~> 7.2", ">= 7.2.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[windows jruby]

# App features
gem "groupdate"
gem "prawn"
gem "prawn-table", "~> 0.2.2"
gem "ransack"
gem "sidekiq"
gem "cssbundling-rails"
gem "jsbundling-rails"
gem "devise", "~> 4.9"
gem "friendly_id", "~> 5.4"
gem "madmin"
gem "name_of_person", github: "basecamp/name_of_person"
gem "noticed", "~> 2.0"
gem "omniauth-facebook", "~> 8.0"
gem "omniauth-github", "~> 2.0"
gem "omniauth-twitter", "~> 1.4"
gem "pretender", "~> 0.3.4"
gem "pundit", "~> 2.1"
gem "sitemap_generator", "~> 6.1"
gem "whenever", require: false
gem "responders", github: "heartcombo/responders", branch: "main"

# i18n (needed in all environments)
gem "rails-i18n", "~> 7.0"

# Performance / deployment helpers
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  # Debugging & safety
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  # i18n dev tool (don’t load in production)
  gem "i18n-tasks", "~> 1.0"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
