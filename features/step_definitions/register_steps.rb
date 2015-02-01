Before do
  @security_questions = [{name: 'What year were you born?', id: '1'},
                         {name: 'Last four digits of SSN or Tax ID number?', id: '2'},
                         {name: 'What is your father\'s middle name?', id: '3'}]
  allow(SecurityQuestions).to receive(:find).and_return(@security_questions)
  session = Capybara::Session.new(:culerity)
  page.set_rack_session(patient_enrollment_uuid: SecureRandom.uuid)
end

When(/^I fill in an activation code$/) do
  visit '/'
  fill_in "code", with: "fhs498"
end

When(/^I accept the TOU\/DPN$/) do
  tou_dpn_agreement = {
    'html' => '<html><body>We think in generalities, but we live in detail.</body></html>',
    'language_code' => 'eng'
  }

  allow_any_instance_of(PatientEnrollment).to receive(:tou_dpn_agreement).and_return(tou_dpn_agreement)

  visit '/patient_enrollments/new/'
  click_on 'Next'

  assert_text('We think in generalities, but we live in detail.')
  sleep(1)
  click_on 'I agree'
  alert = page.driver.browser.switch_to.alert
  alert.send(:accept)
end

When(/^I submit registration info as a new subject$/) do
  @patient_enrollment ||= build :patient_enrollment, uuid: 'enrollment123', login: 'the-dude@mdsol.com',
    password: 'B0wl11ng', answer: 'The Eagles', activation_code: '123456'
  fill_in 'Email', with: @patient_enrollment.login
  fill_in 'Re-enter Email', with: @patient_enrollment.login.upcase
  # FIXME.
  # Sleeps are bad.
  #   It appears click_on is suffering from something like a race condition, and without this sleep,
  #   the button is clicked but the transition is frozen.
  #   The test fails with error 'Unable to find field "Password" (Capybara::ElementNotFound)'
  sleep(1)
  click_on 'Next'

  fill_in 'Password', with: @patient_enrollment.password
  fill_in 'Confirm Password', with: @patient_enrollment.password
  sleep(1)
  click_on 'Next'

  select @security_questions.sample[:name], from: 'Security Question'
  fill_in 'Security Answer', with: @patient_enrollment.answer
  click_on 'Create account'
end

Then(/^I should see a link to download the Patient Cloud app$/) do
  find_link 'Download for iOS'
end

And(/^I should be registered for a study$/) do
  pending
end
