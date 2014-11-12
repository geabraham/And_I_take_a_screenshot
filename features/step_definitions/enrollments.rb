Given(/^I fill in an activation code$/) do
  visit $BASE_URL
  (1..6).each { |e| fill_in "code-#{e}", :with => "#{e}" }
end

And(/^I accept the TOU\/DPN$/) do
  pending
end

And(/^I submit registration info$/) do
  pending
end

Then(/^I should be registered for a study$/) do
  pending
end

And(/^the Subject Service returns an error$/) do
  pending
end

Then(/^I should see a representation of the error from Subject Service$/) do
  pending
end