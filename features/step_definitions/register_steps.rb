When(/^I fill in (a|an) (valid|invalid) activation code$/) do |_, validity|
  activation_code_response = if validity == 'valid'
    allow_any_instance_of(PatientEnrollment).to receive(:tou_dpn_agreement).and_return(@tou_dpn_agreement)
    allow(SecurityQuestions).to receive(:find).and_return(@security_questions)
    double('activation_code').tap do |ac|
      allow(ac).to receive(:attributes).and_return(@activation_code_attrs)
    end
  else
    @error_response_message = 'Activation Code must be in active state'
    double('activation_code').tap do |ac|
      allow(ac).to receive(:attributes).and_return(@invalid_activation_code_attrs)
    end
  end

  allow(Euresource::ActivationCodes).to receive(:get)
    .with(activation_code: @activation_code)
    .and_return(activation_code_response)

  visit '/'
  fill_in 'code', with: @activation_code
  click_on 'Activate'
end

When(/^I accept the TOU\/DPN$/) do
  # Move past the instructional steps page
  click_on 'Next'
  assert_text('We think in generalities, but we live in detail.')
  sleep(1)
  click_on 'I agree'
  alert = page.driver.browser.switch_to.alert
  alert.send(:accept)
end

When(/^I submit registration info as a new subject$/) do
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
  fill_in 'Re-enter Password', with: @patient_enrollment.password
  sleep(1)
  click_on 'Next'

  select @security_question[:name], from: 'Security Question'
  fill_in 'Security Answer', with: @patient_enrollment.answer
end

When(/^the request to create account is successful$/) do
  response_double = double('response').tap {|res| allow(res).to receive(:status).and_return(200)}

  allow(Euresource::PatientEnrollments).to receive(:invoke)
    .with(:register, {uuid: @patient_enrollment_uuid}, {patient_enrollment: @patient_enrollment_register_params})
    .and_return(response_double)

  click_on 'Create my account'
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

  click_on 'Create my account'
end

Then(/^I should see a link to download the Patient Cloud app$/) do
  find_link 'Download for iOS'
end

Then(/^I should see a representation of the error from back\-end service$/) do
  expect(page).to have_content(@error_response_message)
end

And(/^I should be registered for a study$/) do
  # Don't need to do anything
end
