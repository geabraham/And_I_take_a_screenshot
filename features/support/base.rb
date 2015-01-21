# # encoding: utf-8
# # Base cucumber setup common to all profiles
require 'rack_session_access/capybara'

@browser = :firefox

Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, browser: @browser)
end

Capybara.register_driver :selenium do |app|
  http_client = Selenium::WebDriver::Remote::Http::Default.new
  http_client.timeout = 100
  Capybara::Selenium::Driver.new(app, browser: @browser, http_client: http_client)
end

Before '@Headed' do
  Capybara.current_driver = :selenium
end
