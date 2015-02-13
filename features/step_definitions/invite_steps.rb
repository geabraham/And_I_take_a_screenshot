Given(/^patient cloud supports the following country \/ language pairs:$/) do |table|
  mock_tou_dpns = table.hashes.map do |attrs|
    double('tou_dpn_agreement').tap {|tda| allow(tda).to receive(:attributes).and_return(attrs)}
  end
  allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_return(mock_tou_dpns)
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

When(/^I navigate to patient management via study "(.*?)" and site "(.*?)"$/) do |_, site_name|
  site_object = study_or_site_object(site_name, 'sites')
  @current_path = "/patient_management?study_uuid=#{site_object['study_uuid']}&study_site_uuid=#{site_object['uuid']}"
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
