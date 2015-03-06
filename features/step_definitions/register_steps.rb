When(/^I fill in (a|an) (valid|inactive|not_exist) activation code( with a language code of )?([a-z]{3})?$/) do |_, validity, _, lang|
  activation_code_response = if validity == 'valid'
    allow_any_instance_of(PatientEnrollment).to receive(:tou_dpn_agreement).and_return(@tou_dpn_agreement)
    allow(SecurityQuestions).to receive(:find).and_return(@security_questions)
    double('activation_code').tap do |ac|
      if lang
        @activation_code_attrs["language_code"] = lang
        I18n.locale = lang
      end
      allow(ac).to receive(:attributes).and_return(@activation_code_attrs)
    end
  elsif validity=='inactive'
    @error_response_message = 'Activation Code must be in active state'
    double('activation_code').tap do |ac|
      allow(ac).to receive(:attributes).and_return(@invalid_activation_code_attrs)
    end
  elsif validity=='not_exist'
    @error_response_message = 'Response errors: Activation code not found..'
    double('activation_code').tap do |ac|
      allow(ac).to receive(:attributes).and_raise("Response errors: Activation code not found..")
    end
  else

  end

  allow(Euresource::ActivationCodes).to receive(:get)
    .with(activation_code: @activation_code)
    .and_return(activation_code_response)

  visit '/'
  fill_in 'code', with: @activation_code
end

And(/^I click the activate button$/) do
  click_on "Activate"
end

Then(/^I should see the "(.*?)" page$/) do |page|
  #Do nothing
end

When(/^I accept the TOU\/DPN$/) do
  # Move past the instructional steps page
  click_on I18n.t("application.btn_next")
  assert_text('We think in generalities, but we live in detail.')
  sleep(1)
  click_on I18n.t("application.btn_agree")
  alert = page.driver.browser.switch_to.alert
  alert.send(:accept)
end

Then(/^I enter email information for a new subject$/) do
  fill_in I18n.t("registration.email_form.email_label"), with: @patient_enrollment.login
  fill_in I18n.t("registration.email_form.reenter_label"), with: @patient_enrollment.login.upcase
end

And(/^I click on the next button$/) do
  # FIXME.
  # Sleeps are bad.
  #   It appears click_on is suffering from something like a race condition, and without this sleep,
  #   the button is clicked but the transition is frozen.
  #   The test fails with error 'Unable to find field "Password" (Capybara::ElementNotFound)'
  sleep(1)
  click_on I18n.t("application.btn_next")
end

Then(/^I enter password information for a new subject$/) do
  fill_in I18n.t("registration.password_form.password_label"), with: @patient_enrollment.password
  fill_in I18n.t("registration.password_form.reenter_label"), with: @patient_enrollment.password

end

Then(/I enter security question and answer for a new subject$/) do
  select @security_question[:name], from: 'Security Question'
  fill_in I18n.t("registration.security_question_form.answer_label"), with: @patient_enrollment.answer
end



When(/^the request to create account is successful$/) do
  response_double = double('response').tap {|res| allow(res).to receive(:status).and_return(200)}

  allow(Euresource::PatientEnrollments).to receive(:invoke)
    .with(:register, {uuid: @patient_enrollment_uuid}, {patient_enrollment: @patient_enrollment_register_params})
    .and_return(response_double)

  click_on I18n.t("registration.security_question_form.btn_create")
end

And(/^I submit registration info as a new subject$/) do
  steps %Q{
        And I enter email information for a new subject
        And I click on the next button
        And I enter password information for a new subject
        And I click on the next button
        And I enter security question and answer for a new subject
  }
end

When(/^the back\-end service returns an error due to User already existing$/) do
  @error_response_message = 'User already exists'
  response_double = double('response').tap do |res|
    allow(res).to receive(:status).and_return(409)
    allow(res).to receive(:body).and_return(@error_response_message)
  end

  allow(Euresource::PatientEnrollments).to receive(:invoke)
    .with(:register, {uuid: @patient_enrollment_uuid}, {patient_enrollment: @patient_enrollment_register_params})
    .and_return(response_double)

  click_on I18n.t("registration.security_question_form.btn_create")
end

Then(/^I should see a link to download the Patient Cloud app$/) do
  find_link 'Download for iOS'
end

Then(/^I should see a representation of the "(.*?)" from back\-end service$/) do |error|
  expect(page).to have_content(error)
end

Then(/^I should see a representation of the error from back\-end service$/) do
  expect(page).to have_content(@error_response_message)
end

And(/^I should be registered for a study$/) do
  # Don't need to do anything
end
