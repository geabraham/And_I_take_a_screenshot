When(/^I fill in an activation code$/) do
  visit '/'
  (1..6).each { |e| fill_in "code-#{e}", with: "#{e}" }
end

When(/^I accept the TOU\/DPN$/) do
  pe_uuid = SecureRandom.uuid
  page.set_rack_session(patient_enrollment_uuid: pe_uuid)
  allow_any_instance_of(PatientEnrollment).to receive(:tou_dpn_agreement_html).and_return('<html><body>We think in generalities, but we live in detail.</body></html>')
  visit '/patient_enrollments/new/'
  assert_text('We think in generalities, but we live in detail.')
  click_on 'I agree'
end

When(/^I enter my email$/) do
  @patient_enrollment ||= build :patient_enrollment, uuid: 'enrollment123', login: 'the-dude@mdsol.com', 
    password: 'B0wl11ng', security_question: 3, answer: 'The Eagles', activation_code: '123456'
  fill_in 'Email', with: @patient_enrollment.login
  fill_in 'Re-enter Email', with: @patient_enrollment.login
  sleep(1)
  click_on 'Next'
end

When(/^I enter a password$/) do
  fill_in 'Password', with: @patient_enrollment.password
  fill_in 'Confirm Password', with: @patient_enrollment.password
  sleep(1)
  click_on 'Next'
end

When(/^I enter a security question and answer$/) do
  select "What's the worst band in the world?", from: 'Security Question'
  fill_in 'Security Answer', with: @patient_enrollment.answer
  click_on 'Create account'
end

Then(/^I should be registered for a study$/) do
  pending
end
