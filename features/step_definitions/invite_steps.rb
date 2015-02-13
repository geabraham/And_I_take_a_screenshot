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
  @current_path = "/patient_management?study_uuid=#{@current_site_object['study_uuid']}&study_site_uuid=#{@current_site_object['uuid']}"
  visit @current_path
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

When(/^I invite a user with all required attributes$/) do
  @selected_country_language = @mock_tou_dpns.sample.attributes
  country_language_string = "#{@selected_country_language['country']} / #{@selected_country_language['language']}"
  @selected_mock_subject = @mock_subjects.sample.attributes
  select @selected_mock_subject['subject_identifier'], from: 'patient_enrollment_subject'
  select country_language_string, from: 'patient_enrollment_country_language'
end

When(/^the backend service returns an error response$/) do
  mock_invite_error_response_with(StandardError.new())
  click_on 'Invite'
end

When(/^the backend service does not respond$/) do
  mock_invite_error_response_with(Faraday::Error::ConnectionFailed.new('Cannot connect.'))
  click_on 'Invite'
end

When(/^I navigate to patient management via a study and site$/) do
  site = @study_sites.sample
  site_name, study_name = site['name'], @studies.find{|s| s['uuid'] == site['study_uuid']}['name']

  if @user_uuid
    mock_study_sites_request = IMedidataClient::StudySitesRequest.new(user_uuid: @user_uuid, study_uuid: site['study_uuid'])
    stub_request(:get, IMED_BASE_URL + mock_study_sites_request.path).to_return(status: 404, body: 'Not found')
  end

  step %Q(I navigate to patient management via study "#{study_name}" and site "#{site_name}")
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
