Given(/^patient cloud supports the following country \/ language pairs:$/) do |table|
  @mock_tou_dpns = table.hashes.map do |attrs|
    double('tou_dpn_agreement').tap {|tda| allow(tda).to receive(:attributes).and_return(attrs)}
  end
  allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_return(@mock_tou_dpns)
end

Given(/^the following subject names are avaible for site "(.*?)":$/) do |site_name, table|
  site_object = study_or_site_object(site_name, 'sites')
  @mock_subjects = table.hashes.map do |attrs|
    double('subject').tap {|sub| allow(sub).to receive(:attributes).and_return(attrs)}
  end
  allow(Euresource::Subject).to receive(:get).with(:all, {params: {
    study_uuid: site_object['study_uuid'],
    study_site_uuid: site_object['uuid'],
    available: true
  }}).and_return(@mock_subjects)
end

Given(/^the request for available subjects for site "(.*?)" (does not return any subjects|returns any error)$/) do |site_name, return_type|
  site_object = study_or_site_object(site_name, 'sites')
  error = return_type == 'returns any error' ? true : false
  allow(Euresource::Subject).to receive(:get).with(:all, {params: {
    study_uuid: site_object['study_uuid'],
    study_site_uuid: site_object['uuid'],
    available: true
  }}).and_return(error ? ->(){raise StandardError.new()} : [])
end

When(/^I navigate to patient management via study "(.*?)" and site "(.*?)"$/) do |_, site_name|
  @current_site_object = study_or_site_object(site_name, 'sites')
  @current_path = "/patient_management?study_uuid=#{@current_site_object['study_uuid']}&study_site_uuid=#{@current_site_object['uuid']}"
  visit @current_path
end

Then(/^I should be able to select from the following (subjects|country \/ language pairs):$/) do |_, table|
  table.rows.flatten.each do |option_text|
    expect(html).to have_selector("option", text: option_text)
  end
end

When(/^I invite a user with the following attributes:$/) do |table|
  attributes = table.hashes
  initials = attributes.find {|attr| attr['attribute_name'] == 'initials'}
  fill_in 'patient_enrollment_initials', with: initials ? initials['attribute_value'] : nil

  email = attributes.find {|attr| attr['attribute_name'] == 'email'}
  fill_in 'patient_enrollment_email', with: email ? email['attribute_value'] : nil

  subject = attributes.find {|attr| attr['attribute_name'] == 'subject'}
  select subject['attribute_value'], from: 'patient_enrollment_subject'

  country_language = attributes.find {|attr| attr['attribute_name'] == 'country_language'}
  select country_language['attribute_value'], from: 'patient_enrollment_country_language'
end

When(/^I select a subject but I don't select a country \/ language pair$/) do
  select @mock_subjects.sample.attributes['subject_identifier'], from: 'patient_enrollment_subject'
end

Then(/^I am unable to invite a patient$/) do
  expect(find('input#invite-button')['disabled']).to eq('true')
end

When(/^I invite a user with all required attributes$/) do
  @selected_country_language = @mock_tou_dpns.sample.attributes
  country_language_string = "#{@selected_country_language['country']} / #{@selected_country_language['language']}"
  @selected_mock_subject = @mock_subjects.sample.attributes

  select @selected_mock_subject['subject_identifier'], from: 'patient_enrollment_subject'
  select country_language_string, from: 'patient_enrollment_country_language'
end

When(/^the backend service returns an error response$/) do
  allow(Euresource::PatientEnrollment).to receive(:post!).with({patient_enrollment:
    {
      email: '',
      initials: '',
      country_code: @selected_country_language['country_code'],
      language_code: @selected_country_language['language_code'],
      enrollment_type: 'in-person',
      study_uuid: @current_site_object['study_uuid'],
      study_site_uuid: @current_site_object['uuid'],
      subject_id: @selected_mock_subject['subject_identifier']
    }.stringify_keys}, http_headers: {'X-MWS-Impersonate' => @user_uuid}).and_raise(StandardError.new())

  click_on 'Invite'
end

When(/^the backend service does not respond$/) do
  allow(Euresource::PatientEnrollment).to receive(:post!).with({patient_enrollment:
    {
      email: '',
      initials: '',
      country_code: @selected_country_language['country_code'],
      language_code: @selected_country_language['language_code'],
      enrollment_type: 'in-person',
      study_uuid: @current_site_object['study_uuid'],
      study_site_uuid: @current_site_object['uuid'],
      subject_id: @selected_mock_subject['subject_identifier']
    }.stringify_keys}, http_headers: {'X-MWS-Impersonate' => @user_uuid}).and_raise(Faraday::Error::ConnectionFailed.new('Cannot connect.'))

  click_on 'Invite'
end

Then(/^I should see an error message: "(.*?)"$/) do |message|
  expect(page).to have_content(message)
end

Then(/^the subject dropdown should get refreshed$/) do
  expect(page).to have_select('patient_enrollment_subject', selected: 'Subject')
end

Then(/^the only subject option should read "(.*?)"$/) do |selected_value|
  expect(page).to have_select('patient_enrollment_subject', selected: selected_value, count: 1)
end

