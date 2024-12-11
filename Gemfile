source "https://rubygems.org"

gem "rails", "8.0.0.1"

gem "babosa"
gem "bootsnap", require: false
gem "friendly_id"
gem "jbuilder"
gem "jsbundling-rails"
gem "pg", "~> 1.5"
gem "publishing_platform_api_adapters"
gem "publishing_platform_app_config"
gem "publishing_platform_location"
gem "publishing_platform_sso"
gem "puma", ">= 5.0"
gem "sassc-rails"
gem "sprockets-rails"
gem "tzinfo-data", platforms: %i[mswin mswin64 mingw x64_mingw jruby]
gem "terser"

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[mri mswin mswin64 mingw x64_mingw], require: "debug/prelude"
  gem "publishing_platform_rubocop"
end

group :development do
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
  gem "web-console"
end
