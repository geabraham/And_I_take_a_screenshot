When(/^I fill in an activation code$/) do
  visit '/'
  (1..6).each { |e| fill_in "code-#{e}", with: "#{e}" }
end

When(/^I accept the TOU\/DPN$/) do
  allow_any_instance_of(PatientEnrollment).to receive(:tou_dpn_agreement).and_return('<body>We think in generalities, but we live in detail.</body>')
  visit '/patient_enrollments/new/'
  assert_text('We think in generalities, but we live in detail.')
  click_on 'I agree'
end

When(/^I submit registration info as a new subject$/) do
  @patient_enrollment ||= build :patient_enrollment, uuid: 'enrollment123', login: 'the-dude@mdsol.com', 
    password: 'B0wl11ng', security_question: 3, answer: 'The Eagles', activation_code: '123456'
  fill_in 'Email', with: @patient_enrollment.login
  fill_in 'Re-enter Email', with: @patient_enrollment.login
  # FIXME.
  # Sleeps are bad.
  #   It appears click_on is suffering from something like a race condition, and without this sleep, 
  #   the button is clicked but the transition is frozen.
  #   The test fails with error 'Unable to find field "Password" (Capybara::ElementNotFound)'
  sleep(1)
  click_on 'Next'

  fill_in 'Password', with: @patient_enrollment.password
  fill_in 'Confirm Password', with: @patient_enrollment.password
  click_on 'Next'

  select "What's the worst band in the world?", from: 'Security Question'
  fill_in 'Security Answer', with: @patient_enrollment.answer
  click_on 'Create account'
end

Then(/^I should be registered for a study$/) do
  pending
end
