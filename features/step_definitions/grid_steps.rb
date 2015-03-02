Given(/^patient enrollments exist for "(.*?)" and "(.*?)"$/) do |subject_id_1, subject_id_2|
  @patient_enrollments = [subject_id_1, subject_id_2].map do |subj|
    { initials: subj,
      email: "aUser#{subj}@mdsol.com",
      enrollment_type: "in-person",
      activation_code: "G#{subj}K",
      language_code: "ara",
      state: "invited",
      tou_accepted_at: nil,
      study_uuid: @studies[0]['uuid'],
      study_site_uuid: @study_sites[0]['uuid'],
      subject_id: "SUBJ#{subj}",
      created_at: "2015-02-27 20:52:46 UTC" }
  end
  
  mock_last_response = double('last response', status: 200, body: @patient_enrollments.to_json)
  mock_response = double('response', last_response: mock_last_response)
  enrollment_params = { study_uuid: @studies[0]['uuid'], study_site_uuid: @study_sites[0]['uuid'] }
  allow(Euresource::PatientEnrollments).to receive(:get).with(:all, params: enrollment_params, http_headers: { 'X-MWS-Impersonate' => @user_uuid })
    .and_return(mock_response)
end

Given(/^no patient enrollments exist for site "(.*?)"$/) do |site_name|
  site_object = study_or_site_object(site_name, 'sites')
  mock_last_response = double('last response', status: 200, body: [].to_json)
  mock_response = double('response', last_response: mock_last_response)
  enrollment_params = { study_uuid: site_object['study_uuid'], study_site_uuid: site_object['uuid'] }
  allow(Euresource::PatientEnrollments).to receive(:get).with(:all, params: enrollment_params, http_headers: { 'X-MWS-Impersonate' => @user_uuid })
    .and_return(mock_response)
end

Given(/^(\d+) patient enrollments exist for site "(.*?)"$/) do |count, site_name|
  @count = count
  site_object = study_or_site_object(site_name, 'sites')

  patient_enrollments = (1..count.to_i).map do |index|
    { initials: "TEST#{index}",
      email: "a-user#{index}@mdsol.com",
      enrollment_type: "in-person",
      activation_code: "G#{index}K",
      language_code: "ara",
      state: "invited",
      tou_accepted_at: nil,
      study_uuid: site_object['study_uuid'],
      study_site_uuid: site_object['uuid'],
      subject_id: "SUBJ#{index}",
      created_at: "20#{index < 10 ? 00 : index}-02-27 20:52:46 UTC" }
    end
  
  mock_last_response = double('last response', status: 200, body: patient_enrollments.to_json)
  mock_response = double('response', last_response: mock_last_response)
  enrollment_params = { study_uuid: site_object['study_uuid'], study_site_uuid: site_object['uuid'] }
  allow(Euresource::PatientEnrollments).to receive(:get).with(:all, params: enrollment_params, http_headers: { 'X-MWS-Impersonate' => @user_uuid })
    .and_return(mock_response)
end

Given(/^the request for patient enrollments returns an error$/) do
  allow(Euresource::PatientEnrollments).to receive(:get).and_raise(Euresource::ResourceNotFound.new(404,"Live long and prosper."))
end

Then(/^I should see a row for "(.*?)" with an obscured email, an activation code, an? (invited|registered) status, a formatted date, subject and initials$/) do |subject_id, status|
  expect(page).to have_text(format_date(@returned_enrollment[:created_at]))
  expect(page).to have_text(anonymize_email(@returned_enrollment[:email]))
  expect(page).to have_text(@returned_enrollment[:activation_code])
  expect(page).to have_text(@returned_enrollment[:initials])
  expect(page).to have_text(status.capitalize)
  expect(page).to have_text(subject_id)
end

Then(/^I should see a row for each subject with an obscured email, an activation code, an? (invited|registered) status, a formatted date, subject and initials$/) do |status|
  @patient_enrollments.each do |enrollment|
    expect(page).to have_text(format_date(enrollment[:created_at]))
    expect(page).to have_text(anonymize_email(enrollment[:email]))
    expect(page).to have_text(enrollment[:activation_code])
    expect(page).to have_text(enrollment[:initials])
    expect(page).to have_text(status.capitalize)
    expect(page).to have_text(enrollment[:subject_id])
  end
end

Then(/^I should see a message saying "(.*?)"$/) do |message|
  expect(page).to have_text(message)
end

Then(/^I should see that I am on page (\d+) of (\d+)$/) do |current_page, total_pages|
  expect(current_page).to eq(page.find('#current-page')[:value])
  expect(page).to have_selector('#total-pages', text: total_pages)
end

Then(/^(\d+) patient enrollments are displayed$/) do |count|
  expect(page).to have_selector('tr.patient_row', count: count)
end

Then(/^patient enrollments are ordered by date$/) do
  (1..25).each do |index|
    expect(page).to have_selector("tr.patient_row:nth-child(#{26-index})", text: "27-FEB-20#{@count.to_i - 25 + index}")
  end
end

Then(/^there is an active Next Page button$/) do
  expect(page).to have_selector('a.next')
end

Then(/^there is an inactive Previous Page button$/) do
  expect(page).to have_selector('a.disabled.previous')
end
