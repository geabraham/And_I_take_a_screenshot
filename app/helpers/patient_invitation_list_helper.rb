# Retrieves patient_enrollments from Subject service, deserializes and does anonymization/formatting for views
module PatientInvitationListHelper
  def fetch_patient_enrollments
    stubby_return = [{created_at: '5/14/86', subject_identifier: 'SUB029', email: 'todd@blah.org', initials: 'TM', activation_code: 'GW346J', state: 'Pending'},
                    {created_at: '2/18/15', subject_identifier: 'SUB030', email: 'chad@blah.com', initials: 'CV', activation_code: 'FH8492', state: 'Pending'}].to_json
    # the code below here is no joke
    @enrollments = JSON.parse(stubby_return)
    format_enrollments_for_view
  end
  
  def format_enrollments_for_view
    @enrollments
  end
end
