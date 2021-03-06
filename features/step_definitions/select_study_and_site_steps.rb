Given(/^patient management is a part of the following (studies|sites):$/) do |object_type, table|
  table.hashes.map do |object|
    object['uuid'] = SecureRandom.uuid
    if object_type == 'sites'
      object['study_uuid'] = find_object_by_name(@studies, object['study_name'])['uuid']
    end
  end
  instance_variable_set("@#{object_type == 'studies' ? 'studies' : 'study_sites'}", table.hashes)
end

Given(/^I am logged in$/) do
  @user_uuid ||= SecureRandom.uuid
  user_email = 'lt-commander-data@gmail.com'
  cas_extra_attributes = {user_uuid: @user_uuid, user_email: user_email}.stringify_keys
  session = Capybara::Session.new(:culerity)
  page.set_rack_session(cas_extra_attributes: cas_extra_attributes)
  CASClient::Frameworks::Rails::Filter.stub(:filter).and_return(true)

  # Start under the assumption the user has no studies for patient management.
  #
  mock_studies_request = IMedidataClient::StudiesRequest.new(user_uuid: @user_uuid)
  stub_request(:get, IMED_BASE_URL + mock_studies_request.path).to_return(status: 404, body: 'None found')
end

Given(/^I am not logged in$/) do
  # Don't need to do anything!
end

Given(/^I am authorized to manage patients for (?:study|studies) "(.*?)"$/) do |studies|
  step %Q(I am logged in)
  my_studies = studies.split(', ')
  my_studies = @studies.select {|s| my_studies.include?(s['name'])}
  mock_studies_request = IMedidataClient::StudiesRequest.new(user_uuid: @user_uuid)
  stub_request(:get, IMED_BASE_URL + mock_studies_request.path).to_return(status: 200, body: {'studies' => my_studies}.to_json)

  my_studies.each do |study|
    mock_study_request = IMedidataClient::StudyRequest.new(user_uuid: @user_uuid, study_uuid: study['uuid'])
    stub_request(:get, IMED_BASE_URL + mock_study_request.path).to_return(status: 200, body: {'study' => study}.to_json)

    mock_study_sites_request = IMedidataClient::StudySitesRequest.new(user_uuid: @user_uuid, study_uuid: study['uuid'])
    study_sites = @study_sites.select {|ss| ss['study_uuid'] == study['uuid']}
    stub_request(:get, IMED_BASE_URL + mock_study_sites_request.path).to_return(status: 200, body: {'study_sites' => study_sites}.to_json)
  end
end

When(/^I navigate to patient management via the apps pane in iMedidata$/) do
  @current_path = '/patient_management'
  visit @current_path
end

When(/^I navigate to patient management by directly placing the url in the browser$/) do
  step %Q(I navigate to patient management via the apps pane in iMedidata)
end

When(/^I navigate to patient management via study "(.*?)" in iMedidata$/) do |study_name|
  study_uuid = find_object_by_name(@studies, study_name)['uuid']
  @current_path = "/patient_management?study_uuid=#{study_uuid}"
  visit @current_path
end

When(/^I select "(.*?)" from the list of (studies|sites)$/) do |object_name, object_type|
  object = study_or_site_object(object_name, object_type)
  instance_variable_set("@selected_#{object_type.singularize}_uuid", object['uuid'])
  select object['name'], from: "patient_management_#{object_type == 'studies' ? 'study' : 'study_site'}"
end

Then(/^I should see a list of (studies|sites):$/) do |object_type, table|
  table.rows.flatten.each do |object_name|
    object = study_or_site_object(object_name, object_type)
    expect(html).to have_selector("option[@value='#{object['uuid']}']", text: object['name'])
  end
end

Then(/^I should see an active launch button$/) do
  expect(page).to have_button('Launch')
  expect(html).to have_xpath("//a[@href='/patient_management?study_uuid=#{@selected_study_uuid}&study_site_uuid=#{@selected_site_uuid}']")
end

Then(/^I should see "(.*?)" pre\-selected in the list of studies$/) do |study_name|
  @selected_study_uuid = find_object_by_name(@studies, study_name)['uuid']
  expect(page).to have_select('patient_management_study', selected: study_name)
end

Then(/^I should see the message "(.*?)"$/) do |message|
  expect(page).to have_content(message)
end

Then(/^I should be redirected to the login page$/) do
  url = "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{@current_path}"
  cas_url="#{CAS_BASE_URL}/login?service=#{CGI.escape(url)}"
  expect(current_url).to eq(cas_url)
end

Then(/^I should see a not found error page$/) do
  expect(page).to have_content(I18n.t('error.status_404.heading'))
  expect(page).to have_content(I18n.t('error.status_404.message'))
end
