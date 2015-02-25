# Retrieves patient_enrollments from Subject service, deserializes and does anonymization/formatting for views
module PatientInvitationListHelper
  def fetch_patient_enrollments
    # actual request will replace this
    stubby_return = [{created_at: '2014-02-18 23:08:08', subject_identifier: 'SUB029', email: 'todfsdfsdfdsfsdfsdfdd@blahhahhahahaha.org', initials: 'TM', activation_code: 'GW346J', state: 'Pending'},
                    {created_at: '2015-02-18 11:08:08', subject_identifier: 'SUB030', email: 'chad@hotmail.com', initials: 'CV', activation_code: 'FH8492', state: 'Pending'},
                    {created_at: '2013-02-18 07:08:08', subject_identifier: 'SUB031', email: 'aimee@gmail.com', initials: 'AB', activation_code: 'ASDF98', state: 'Registered'},
                    {created_at: '2013-01-18 06:08:08', subject_identifier: 'SUB032', email: 'kent@mdsol.com', initials: 'KD', activation_code: 'SFH839', state: 'Pending'}]
                    
    (1..100).each { |a| stubby_return << {created_at: '2012-02-18 06:08:08', subject_identifier: "dup#{a}", email: "todd#{a}@mdsol.com", initials: "#{a}", activation_code: "SFH#{a}", state: 'Pending'} }
    # real code below
    @enrollments = stubby_return.sort_by { |e| e[:created_at] }.reverse
    @enrollments.each { |e| format_and_anonymize(e) }
  end
  
  def format_and_anonymize(enrollment)
    enrollment[:email] = anonymize_email(enrollment[:email])
    #TODO remove nil check once created_at is added to PatientEnrollment resource
    enrollment[:created_at] = format_date(enrollment[:created_at].nil? ? Date.today.to_s : enrollment[:created_at])
    enrollment
  end
  
  private
  def anonymize_email(email)
    user = email.split('@').first.chars
    user = user.take(2).join 
    user << '*' * (user.length > 20 ? 18 : user.length - 2) unless user.length <= 2
    
    domain = email.split('@').last.split('.').first.chars
    domain = domain.take(2).join 
    domain << '*' * (domain.length > 10 ? 8 : domain.length - 2) unless domain.length <= 2
    
    tld = email.split('@').last.split('.').from(1).join('.')
    
    "#{user}@#{domain}.#{tld}"
  end
  
  def format_date(date)
    Date.strptime(date).strftime('%d-%^b-%Y')
  end
end
