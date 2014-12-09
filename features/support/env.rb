require 'cucumber/rails'
require 'cucumber/rspec/doubles'
require 'webmock/cucumber'
require 'rack_session_access/capybara'

ActionController::Base.allow_rescue = false

WebMock.disable_net_connect!(allow_localhost: true)

Before do
  Rails.cache.clear
end

After do
  WebMock.reset!
end

World(FactoryGirl::Syntax::Methods)
