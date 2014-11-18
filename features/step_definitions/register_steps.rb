When(/^I fill in an activation code$/) do
  visit $BASE_URL
  (1..6).each { |e| fill_in "code-#{e}", :with => "#{e}" }
end

When(/^I accept the TOU\/DPN$/) do
  # TODO: Fill in with the correct code
end

When(/^I submit registration info for a new subject$/) do
  # TODO: Stub request for security questions
  # TODO: Make this work with VCR Gem.

  # TODO: Remove code that navigates to this page directly.
  visit "/patient_enrollments/new"

  @patient_enrollment ||= build :patient_enrollment, uuid: 'enrollment123', login: 'the-dude@mdsol.com',
    password: 'B0wl1ng', security_question: 3, answer: 'The Eagles', activation_code: '123456'


  fill_in 'E-mail Address', with: @patient_enrollment.login
  fill_in 'Confirm E-mail Address', with: @patient_enrollment.login
  fill_in 'Password', with: @patient_enrollment.password
  fill_in 'Confirm Password', with: @patient_enrollment.password
  select "What's the worst band in the world?", from: 'Security Question'
  fill_in 'Answer', with: @patient_enrollment.answer
  #click_on 'Submit' TODO uncomment once this is implemented
end

Then(/^I should be registered for a study$/) do
  # TODO: Fill in with the correct code
  # TODO: Fix URL
  pending
  #expect(request(:post, 'http://subjects-sandbox.imedidata.net/enrollments/enrollment123').with(body: {
  #  activation_code: @patient_enrollment.activation_code,
  #  login: @patient_enrollment.login,
  #  password: @patient_enrollment.password,
  #  security_question_1: @patient_enrollment.security_question_1,
  #  answer_1: @patient_enrollment.answer_1,
  #  security_question_2: @patient_enrollment.security_question_2,
  #  answer_2: @patient_enrollment.answer_2
  #})).to have_been_made.once
end
