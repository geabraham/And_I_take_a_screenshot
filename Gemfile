source 'https://rubygems.org'

gem 'rails', '~> 4.1.7'
gem 'passenger', '~> 4.0'
gem 'haml-rails', '~> 0.5.3'
gem 'json', '~> 1.8.1'
gem 'haml', '~> 4.0.5'

gem 'faraday', '~> 0.8.9'
gem 'coffee-script', '~> 2.3.0'
gem 'node'

gem 'rack-status', '~> 1.0.0'


# Medidata Gems
# UI Gems
gem 'astinus', git: 'git@github.com:mdsol/astinus.git', tag: 'v0.4.0'

gem 'sandman-rails', git: 'git@github.com:mdsol/sandman-rails.git', tag: 'v0.4.1'
gem 'hollywood', git: 'git@github.com:mdsol/hollywood.git', branch: 'develop'

gem 'grandmaster', git: 'git@github.com:mdsol/grandmaster.git', tag: 'v1.4.2', require: 'checkmate/grandmaster'

gem 'eureka_tools', git: 'git@github.com:mdsol/eureka_tools.git', branch: 'develop'
gem 'eureka-client', git: 'git@github.com:mdsol/eureka-client.git', branch: 'develop'
gem 'rack-cache', git: 'git@github.com:mdsol/rack-cache.git', branch: '1.3-stable'
gem 'api_pagination', git: 'git@github.com:mdsol/api_pagination.git', tag: 'v0.0.12'

gem 'mauth-client', git: 'git@github.com:mdsol/mauth-client.git', tag: 'v2.7.2'

gem 'mdsol-tools', git: 'git@github.com:mdsol/mdsol-tools.git', tag: 'v0.3.2'

gem 'dice_bag', git: 'git@github.com:mdsol/dice_bag.git', tag: 'v0.8.0'
gem 'dice_bag-mdsol', git: 'git@github.com:mdsol/dice_bag-mdsol.git'

# gem 'newrelic_rpm', '~> 3.9'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails',   '~> 4.0.3'
gem 'uglifier', '>= 2.5.3'
# gem 'asset_sync', '~> 1.1.0'

gem 'nokogiri', '~> 1.6.3'

group :development do
  gem 'guard-rspec'
  gem 'minitest'
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem 'webmock', '~> 1.20.0'
  gem 'cucumber', '~> 1.3.17'
  gem 'selenium-webdriver', '~> 2.43.0'

  gem 'cucumber-rails', require: false
  gem 'simplecov'
end

group :test, :development do
  gem 'rspec', '~> 3.1'
  gem 'rspec-rails', '~> 3.1'
  gem 'kender', git: 'git@github.com:mdsol/kender.git', branch: 'master'
  gem 'shamus', git: 'git@github.com:mdsol/shamus.git', tag: '2013.3.0'
  gem 'brakeman', '~> 2.6.3'
  gem 'pry'
  gem 'pry-nav'
  gem 'capybara', '~> 2.4.4'
  gem 'factory_girl', '~> 3.5'
  gem 'gem_goblin', git: 'git@github.com:mdsol/gem_goblin.git', branch: 'develop'
  gem 'jasmine'
  gem 'jasmine-rails', '~> 0.10.2'
  gem 'jasmine-jquery-rails'
end

# Used in Blueprint/Sandman Docs
gem 'simple-navigation'
