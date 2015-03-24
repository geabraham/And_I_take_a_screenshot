# Shamus exposes hooks to run arbitrary code to run at certain points of a scenario's execution.
# The available hooks are before_scenario, before_step, after_scenario, after_step.

######################LEGACY SCREENSHOT CODE############################################################################
# NOTE: Leaving this in for now, so we're still taking screenshots. This needs to come out if we want to do manual screenshots.
# Shamus.after_step do |step|
#   # Everything in this block will be executed after every cucumber step.
#
#   # Take a screenshot if and only if this step was a When/Then step.
#   take_screenshot if when_or_then_step?(step) && (!part_of_scenario_outline?(step) || in_examples?(step))
#   response_object = Capybara.current_session.driver.response rescue nil
# end

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
########################################################################################################################


# Takes a screenshot for the validation portal.
def take_screenshot(caption = nil)
  print_to_output(caption) if caption

  if Shamus.current.present?
    filename = Shamus.current.current_step.add_inline_asset(".png")
    Capybara.current_session.driver.browser.save_screenshot(filename)
  end
end

# prints text to console or shamus output
def print_to_output(text)
  if Shamus.current.present?
    asset = Shamus.current.current_step.add_inline_asset('.txt', Shamus::Cucumber::InlineAssets::RENDER_AS_TEXT)
    File.open(asset, 'w') {|f| f.puts text }
  else
    puts text
  end
end
