# Shamus exposes hooks to run arbitrary code to run at certain points of a scenario's execution.
# The available hooks are before_scenario, before_step, after_scenario, after_step.
Shamus.after_step do |step|
  # Everything in this block will be executed after every cucumber step.

  # Take a screenshot if and only if this step was a When/Then step.
  take_screenshot(step.add_inline_image) if when_or_then_step?(step) && (!part_of_scenario_outline?(step) || in_examples?(step))
  response_object = Capybara.current_session.driver.response rescue nil
end

def in_examples?(step)
  step.container.respond_to?(:in_examples?) && step.container.in_examples?
end

def part_of_scenario_outline?(step)
  step.container.respond_to?(:examples)
end

# Return true if the given step has a keyword of When or Then, and false otherwise.
def when_or_then_step?(step)
  step.respond_to?(:keyword) && %w(When Then).include?(step.keyword.strip)
end

# Your specific driver's screenshot logic goes in this method.
def take_screenshot(filename)
  driver = Capybara.current_session.driver
  if driver.browser.respond_to?(:save_screenshot)
    begin
      driver.browser.save_screenshot(filename)
    rescue
      Rails.logger.warn("Couldn't capture screenshot.")
    end
  else
    Rails.logger.warn("Your current driver (#{Capybara.current_session.driver}) is unable to take screenshots.")
  end
end
