Before do
  @security_questions = [{name: 'What year were you born?', id: '1'},
                         {name: 'Last four digits of SSN or Tax ID number?', id: '2'},
                         {name: 'What is your father\'s middle name?', id: '3'}]
  allow(RemoteSecurityQuestions).to receive(:find_or_fetch).and_return(@security_questions)

  session = Capybara::Session.new(:culerity)
  @patient_enrollment_uuid = SecureRandom.uuid
  @activation_code = ([*('A'..'Z'),*('0'..'9')] - %w(I O 1 0)).sample(6).join
  page.set_rack_session(patient_enrollment_uuid: @patient_enrollment_uuid)
  page.set_rack_session(activation_code: @activation_code)
end

When(/^I fill in an activation code$/) do
  visit '/'
  fill_in "code", with: @activation_code
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
  @patient_enrollment ||= build :patient_enrollment, uuid: @patient_enrollment_uuid, login: 'the-dude@mdsol.com', 
    password: 'B0wl11ng', answer: 'The Eagles', activation_code: @activation_code

  @security_question = @security_questions.sample
  @patient_enrollment_register_params = {
    login: @patient_enrollment.login,
    password: @patient_enrollment.password,
    activation_code: @activation_code,
    security_question_id: @security_question[:id],
    answer: @patient_enrollment.answer,
    tou_accepted_at: /[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} [-|\+|][0-9]{4}/
  }
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

  select @security_question[:name], from: 'Security Question'
  fill_in 'Security Answer', with: @patient_enrollment.answer
end

When(/^the request to create account is successful$/) do
  response_double = double('response').tap {|res| allow(res).to receive(:status).and_return(200) }

  allow(Euresource::PatientEnrollments).to receive(:invoke)
    .with(:register, {uuid: @patient_enrollment_uuid}, {patient_enrollment: @patient_enrollment_register_params})
    .and_return(response_double)

  click_on 'Create account'
end

When(/^the back\-end service returns an error$/) do
  @error_response_message = 'User already exists'
  response_double = double('response').tap do |res|
    allow(res).to receive(:status).and_return(409)
    allow(res).to receive(:body).and_return(@error_response_message)
  end

  allow(Euresource::PatientEnrollments).to receive(:invoke)
    .with(:register, {uuid: @patient_enrollment_uuid}, {patient_enrollment: @patient_enrollment_register_params})
    .and_return(response_double)

  click_on 'Create account'
end

Then(/^I should see a link to download the Patient Cloud app$/) do
  find_link 'Download for iOS'
end

Then(/^I should see a representation of the error from back\-end service$/) do
  expect(page).to have_content("Unable to complete registration: #{@error_response_message}")
end

And(/^I should be registered for a study$/) do
  # Don't need to do anything
end
