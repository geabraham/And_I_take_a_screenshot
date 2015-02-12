Given(/^patient cloud supports the following country \/ language pairs:$/) do |table|
  mock_tou_dpns = table.hashes.map do |attrs|
    double('tou_dpn_agreement').tap {|tda| allow(tda).to receive(:attributes).and_return(attrs)}
  end
  allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_return(mock_tou_dpns)
end

Given(/^the following subject names are avaible for site "(.*?)":$/) do |site_name, table|
  site_object = study_or_site_object(site_name, 'sites')
  mock_subjects = table.hashes.map do |attrs|
    double('subject').tap {|sub| allow(sub).to receive(:attributes).and_return(attrs)}
  end
  allow(Euresource::Subject).to receive(:get).with(:all, {params: {
    study_uuid: site_object['study_uuid'],
    study_site_uuid: site_object['uuid'],
    available: true
  }}).and_return(mock_subjects)
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
