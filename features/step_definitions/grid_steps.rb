include PatientInvitationListHelper

Then(/^I should see a row for "(.*?)" with an obscured email, an activation code, a(|n) (invited|registered) status, a formatted date, subject and initials$/) do |subject_id, _, status|
  page.should have_text(format_date(@returned_enrollment[:created_at]))
  page.should have_text(anonymize_email(@returned_enrollment[:email]))
  page.should have_text(@returned_enrollment[:activation_code])
  page.should have_text(@returned_enrollment[:initials])
  page.should have_text(status)
  page.should have_text(subject_id)
end

Given(/^no patient enrollments exist for site "(.*?)"$/) do |site_name|
  site_object = study_or_site_object(site_name, 'sites')
  mock_last_response = double('last response').tap do |lr| 
    allow(lr).to receive(:status).and_return(200) 
    allow(lr).to receive(:body).and_return([].to_json)
  end
  mock_response = double('response').tap { |re| allow(re).to receive(:last_response).and_return(mock_last_response) }
  enrollment_params = { study_uuid: site_object['study_uuid'], study_site_uuid: site_object['uuid'] }
  allow(Euresource::PatientEnrollments).to receive(:get).with(:all, params: enrollment_params, http_headers: { 'X-MWS-Impersonate' => @user_uuid })
    .and_return(mock_response)
end