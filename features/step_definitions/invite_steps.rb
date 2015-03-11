Given(/^patient cloud supports the following country \/ language pairs:$/) do |table|
  @mock_tou_dpns = table.hashes.map do |attrs|
    double('tou_dpn_agreement').tap {|tda| allow(tda).to receive(:attributes).and_return(attrs)}
  end
  allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_return(@mock_tou_dpns)
end

Given(/^the following subject names are available for site "(.*?)":$/) do |site_name, table|
  site_object = study_or_site_object(site_name, 'sites')
  @mock_subjects = table.hashes.map do |attrs|
    double('subject').tap {|sub| allow(sub).to receive(:attributes).and_return(attrs)}
  end
  allow(Euresource::Subject).to receive(:get).with(:all, {params: {
    study_uuid: site_object['study_uuid'],
    study_site_uuid: site_object['uuid'],
    available: true
  # Remove a subject so if this is called a second time we get a different set
  }}).and_return(@mock_subjects, @mock_subjects[0..-2])
end

Given(/^the request for available subjects for site "(.*?)" (does not return any subjects|returns any error)$/) do |site_name, return_type|
  site_object = study_or_site_object(site_name, 'sites')
  error = return_type == 'returns any error' ? true : false
  subject_params = {params: {study_uuid: site_object['study_uuid'], study_site_uuid: site_object['uuid'], available: true}}
  allow(Euresource::Subject).to receive(:get).with(:all, subject_params) { error ? raise(StandardError.new) : [] }
end

When(/^I navigate to patient management via study "(.*?)" and site "(.*?)"$/) do |_, site_name|
  @current_site_object = study_or_site_object(site_name, 'sites')
  @current_path = "/patient_management?study_site_uuid=#{@current_site_object['uuid']}&study_uuid=#{@current_site_object['study_uuid']}"
  visit @current_path
end

When(/I invite a user with the following attributes:$/) do |table|
  attributes = table.hashes
  initials = attributes.find {|attr| attr['attribute_name'] == 'initials'}
  fill_in 'patient_enrollment_initials', with: initials ? initials['attribute_value'] : nil

  email = attributes.find {|attr| attr['attribute_name'] == 'email'}
  fill_in 'patient_enrollment_email', with: email ? email['attribute_value'] : nil

  subject = attributes.find {|attr| attr['attribute_name'] == 'subject'}
  select subject['attribute_value'], from: 'patient_enrollment_subject'

  country_language = attributes.find {|attr| attr['attribute_name'] == 'country_language'}
  select country_language['attribute_value'], from: 'patient_enrollment_country_language'
  
  params_for_patient_enrollment = { patient_enrollment:
    { email: email['attribute_value'],
      initials: initials['attribute_value'],
      country_code: "ISR",
      language_code: "ara",
      subject_id: subject['attribute_value'],
      enrollment_type: "in-person",
      study_uuid: @current_site_object['study_uuid'],
      study_site_uuid: @current_site_object['uuid'] } }
  http_headers = { http_headers: { 'X-MWS-Impersonate' => @user_uuid } }
  
  @returned_enrollment = 
    { initials: initials['attribute_value'],
      email: email['attribute_value'],
      enrollment_type: "in-person",
      activation_code: "6VK7AW",
      language_code: "ara",
      state: "invited",
      tou_accepted_at: nil,
      study_uuid: @current_site_object['study_uuid'],
      study_site_uuid: @current_site_object['uuid'],
      subject_id: subject['attribute_value'],
      created_at: "2015-02-27 20:52:46 UTC" }
  last_response = double('last object').tap { |lr| allow(lr).to receive(:body).and_return(@returned_enrollment.to_json) }
  response_object = double('response object').tap { |ro| allow(ro).to receive(:last_response).and_return(last_response) }
  
  allow(Euresource::PatientEnrollment).to receive(:post!)
    .with(params_for_patient_enrollment, http_headers)
    .and_return(response_object)
  allow(response_object).to receive(:is_a?).with(Euresource::PatientEnrollment).and_return(true)
  
end

When(/^I select a subject but I don't select a country \/ language pair$/) do
  select @mock_subjects.sample.attributes['subject_identifier'], from: 'patient_enrollment_subject'
end

When(/^I invite a user with all required attributes$/) do
  @selected_country_language = @mock_tou_dpns.sample.attributes
  country_language_string = "#{@selected_country_language['country']} / #{@selected_country_language['language']}"
  @selected_mock_subject = @mock_subjects.sample.attributes
  select @selected_mock_subject['subject_identifier'], from: 'patient_enrollment_subject'
  select country_language_string, from: 'patient_enrollment_country_language'
end

When(/^the backend service returns an error response due to subject id already existing$/) do
  mock_invite_error_response_with(StandardError.new())
  click_on 'Invite'
end

When(/^the backend service does not respond due to imedidata or subject service being down$/) do
  mock_invite_error_response_with(Faraday::Error::ConnectionFailed.new('Cannot connect.'))
  click_on 'Invite'
end

When(/^I am logged in but not authorized to access a study site$/) do
  step %Q(I am logged in)
  site = @study_sites.sample
  if @user_uuid
    mock_study_sites_request = IMedidataClient::StudySitesRequest.new(user_uuid: @user_uuid, study_uuid: site['study_uuid'])
    stub_request(:get, IMED_BASE_URL + mock_study_sites_request.path).to_return(status: 404, body: 'Not found')
  end
end

When(/^I navigate to patient management for a study site by directly placing the url in the browser$/) do
  @study_name='TestStudy001'
  @site_name='DeepSpaceStation'
  step %Q(I navigate to patient management via study "#{@study_name}" and site "#{@site_name}")
end

When(/^I navigate to patient management for a study site for which I am not authorized$/) do
  steps %Q{And I am authorized to manage patients for study "TestStudy001"
           And I navigate to patient management for a study site by directly placing the url in the browser
  }
end

Then(/^I am unable to invite a patient$/) do
  expect(find('input#invite-button')['disabled']).to eq('true')
end

Then(/^I should be able to select from the following (subjects|country \/ language pairs):$/) do |_, table|
  table.rows.flatten.each do |option_text|
    expect(html).to have_selector("option", text: option_text)
  end
end

Then(/^I should see an error message: "(.*?)"$/) do |message|
  expect(page).to have_content(message)
end

Then(/^the subject dropdown should get refreshed$/) do
  expect(page).to have_select('patient_enrollment_subject', selected: 'Subject')
  # Expected length is the total number of mock subjects we started with,
  #   minus 1 we removed in the second response and plus 1 for the default option.
  #
  expect(page).to have_selector('#patient_enrollment_subject option', count: @mock_subjects.length)
end

Then(/^the only subject option should read "(.*?)"$/) do |selected_value|
  expect(page).to have_select('patient_enrollment_subject', selected: selected_value, count: 1)
end

Then(/^I should see an error page with the message:$/) do |message|
  expect(page).to have_selector('.page-header-text h4', text: 'Error')
  expect(page).to have_content(message.headers.first)
end
