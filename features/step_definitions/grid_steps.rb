include PatientInvitationListHelper

Then(/^I should see a row for "(.*?)" with an obscured email, an activation code, a(|n) (invited|registered) status, a formatted date, subject and initials$/) do |subject_id, _, status|
  page.should have_text(format_date(@returned_enrollment[:created_at]))
  page.should have_text(anonymize_email(@returned_enrollment[:email]))
  page.should have_text(@returned_enrollment[:activation_code])
  page.should have_text(@returned_enrollment[:initials])
  page.should have_text(status)
  page.should have_text(subject_id)
  
end