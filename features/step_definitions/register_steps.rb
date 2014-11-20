When(/^I fill in an activation code$/) do
  visit '/'
  (1..6).each { |e| fill_in "code-#{e}", with: "#{e}" }
end

When(/^I accept the TOU\/DPN$/) do
  pending
end

When(/^I submit registration info for a new subject$/) do
  pending
end

Then(/^I should be registered for a study$/) do
  pending
end
