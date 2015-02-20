# Retrieves patient_enrollments from Subject service, deserializes and does anonymization/formatting for views
module PatientInvitationListHelper
  def fetch_patient_enrollments
    # actual request will replace this
    stubby_return = [{created_at: '2/18/14', subject_identifier: 'SUB029', email: 'todd@blah.org', initials: 'TM', activation_code: 'GW346J', state: 'Pending'},
                    {created_at: '2/18/16', subject_identifier: 'SUB030', email: 'chad@hotmail.com', initials: 'CV', activation_code: 'FH8492', state: 'Pending'},
                    {created_at: '2/18/15', subject_identifier: 'SUB031', email: 'aimee@gmail.com', initials: 'AB', activation_code: 'ASDF98', state: 'Registered'},
                    {created_at: '2/18/15', subject_identifier: 'SUB032', email: 'kent@mdsol.com', initials: 'KD', activation_code: 'SFH839', state: 'Pending'}]
                    
    (1..100).each { |a| stubby_return << {created_at: '1/1/1', subject_identifier: "dup#{a}", email: "todd#{a}@mdsol.com", initials: "#{a}", activation_code: "SFH#{a}", state: 'Pending'} }
    # the code below here is no joke
    @enrollments = stubby_return
    #@enrollments.each { |e| e['email'] = anonymize_email(e['email']) }
    #TODO localize dates?
  end
  
  def anonymize_email(email)
    first_part = email.split('@').first
    #email.sub(first_part, anonymized_first_part)
  end
end
