# -------------------------------------------------------------------
#
# The main Minotaur automation class - provides an interface to the
# browser testing library.
#
# -------------------------------------------------------------------
require 'selenium/webdriver'
require 'capybara'

private

def parse_environment_variable name, value_if_null = ""
  (ENV[name] || value_if_null).gsub("%20", " ")
end

public

$BASE_SERVER = parse_environment_variable "BASE_SERVER"
$BASE_PORT = parse_environment_variable "BASE_PORT"

$BASE_URL = "http://#{$BASE_SERVER}:#{$BASE_PORT}"

supported_browsers = [:firefox, :chrome]

supported_browsers.each do |browser|
  Capybara.register_driver browser do |app|
    profile = "Selenium::WebDriver::#{browser.capitalize}::Profile".constantize.new
    case browser
    when :firefox
      # Add profile settings
    when :chrome
      # Add profile settings
    else
      raise "Non-supported browser provided: #{browser.to_s}"
    end
    Capybara::Selenium::Driver.new(app, browser: browser, profile: profile)
  end

end

Capybara.app_host = $BASE_SERVER
Capybara.server_port = $BASE_PORT
Capybara.run_server = true
Capybara.default_wait_time = 5

chosen_browser = ENV['CAPYBARA_BROWSER'].try(:to_sym)
chosen_browser = :firefox unless supported_browsers.include?(chosen_browser)
Capybara.default_driver = chosen_browser
