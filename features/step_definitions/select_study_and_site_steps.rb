Given(/^the following studies exist:$/) do |table|
  table.hashes.map {|study| study['uuid'] = SecureRandom.uuid}
  @studies = table.hashes
end

Given(/^the following sites exist:$/) do |table|
  table.hashes.map do |study_site|
    study_site['uuid'] = SecureRandom.uuid
    study_site['study_uuid'] = @studies.find{|study| study['name'] == study_site['study_name']}['uuid']
  end
  @study_sites = table.hashes
end

Given(/^I am logged in$/) do
  @user_uuid = SecureRandom.uuid
  @user_email = 'lt-commander-data@gmail.com'
  @cas_extra_attributes = {user_uuid: @user_uuid, user_email: @user_email}.stringify_keys
  session = Capybara::Session.new(:culerity)
  page.set_rack_session(cas_extra_attributes: @cas_extra_attributes)
  CASClient::Frameworks::Rails::Filter.stub(:filter).and_return(true)
end

Given(/^I am authorized to manage patients for studies "(.*?)"$/) do |studies|
  my_studies = studies.split(', ')
  @my_studies = @studies.select {|s| my_studies.include?(s['name'])}
  mock_studies_request = IMedidataClient::StudiesRequest.new(user_uuid: @user_uuid)
  stub_request(:get, IMED_BASE_URL + mock_studies_request.path).to_return(status: 200, body: {'studies' => @my_studies}.to_json)

  @my_studies.each do |study|
    mock_study_sites_request = IMedidataClient::StudySitesRequest.new(user_uuid: @user_uuid, study_uuid: study['uuid'])
    study_sites = @study_sites.select {|ss| ss['study_uuid'] == study['uuid']}
    stub_request(:get, IMED_BASE_URL + mock_study_sites_request.path).to_return(status: 200, body: {'study_sites' => study_sites}.to_json)
  end
end

When(/^I navigate to patient management via the apps pane in iMedidata$/) do
  visit '/patient_management'
end

Then(/^I should see a list of my studies$/) do
  @my_studies.each do |study|
    expect(html).to have_selector("option[@value='#{study['uuid']}']", text: study['name'])
  end
end

When(/^I select "(.*?)" from the list of (studies|sites)$/) do |object_name, object_type|
  if object_type == 'studies'
    @selected_study_uuid = @studies.find {|s| s['name'] == object_name}['uuid']
    select object_name, from: 'patient_management_study'
  elsif object_type == 'sites'
    @selected_site_uuid = @study_sites.find {|s| s['name'] == object_name}['uuid']
    select object_name, from: 'patient_management_study_site'
  end
end

Then(/^I should see a list of sites:$/) do |table|
  study_sites = table.rows.flatten
  study_sites.each do |study_site|
    study_site_uuid = @study_sites.find { |ss| ss['name'] == study_site }['uuid']
    expect(html).to have_selector("option[@value='#{study_site_uuid}']", text: study_site)
  end
end

Then(/^I should be able to navigate to the patient management table$/) do
  expect(html).to have_xpath("//a[@href='/patient_management?study_uuid=#{@selected_study_uuid}&study_site_uuid=#{@selected_site_uuid}']")
end
