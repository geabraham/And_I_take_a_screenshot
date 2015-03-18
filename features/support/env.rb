require 'cucumber/rails'
require 'cucumber/rspec/doubles'
require 'webmock/cucumber'

ActionController::Base.allow_rescue = false

WebMock.disable_net_connect!(allow_localhost: true)

Before do
  Rails.cache.clear
end

After do
  WebMock.reset!
  I18n.locale = I18n.default_locale
end

World(FactoryGirl::Syntax::Methods)
