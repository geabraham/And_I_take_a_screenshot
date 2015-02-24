# Retrieves patient_enrollments from Subject service, deserializes and does anonymization/formatting for views
module PatientInvitationListHelper
  def fetch_patient_enrollments
    # actual request will replace this
    stubby_return = [{created_at: '2014-02-18 23:08:08', subject_identifier: 'SUB029', email: 'todfsdfsdfdsfsdfsdfdd@blahhahhahahaha.org', initials: 'TM', activation_code: 'GW346J', state: 'Pending'},
                    {created_at: '2015-02-18 11:08:08', subject_identifier: 'SUB030', email: 'chad@hotmail.com', initials: 'CV', activation_code: 'FH8492', state: 'Pending'},
                    {created_at: '2013-02-18 07:08:08', subject_identifier: 'SUB031', email: 'aimee@gmail.com', initials: 'AB', activation_code: 'ASDF98', state: 'Registered'},
                    {created_at: '2013-02-18 06:08:08', subject_identifier: 'SUB032', email: 'kent@mdsol.com', initials: 'KD', activation_code: 'SFH839', state: 'Pending'}]
                    
    (1..100).each { |a| stubby_return << {created_at: '2013-02-18 06:08:08', subject_identifier: "dup#{a}", email: "todd#{a}@mdsol.com", initials: "#{a}", activation_code: "SFH#{a}", state: 'Pending'} }
    # real code below
    @enrollments = stubby_return
    @enrollments.each do |enrollment| 
      enrollment[:email] = anonymize_email(enrollment[:email])
      enrollment[:created_at] = Date.strptime(enrollment[:created_at]).strftime('%d-%^b-%Y')
    end
  end
  
  def anonymize_email(email)
    user = email.split('@').first.chars
    user = user.take(2).join << '*' * (user.length > 20 ? 18 : user.length - 2)
    
    domain = email.split('@').last.split('.').first.chars
    domain = domain.take(2).join << '*' * (domain.length > 10 ? 8 : domain.length - 2)
    
    tld = email.split('@').last.split('.').from(1).join('.')
    
    "#{user}@#{domain}.#{tld}"
  end
end
