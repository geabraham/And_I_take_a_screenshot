# Retrieves patient_enrollments from Subject service, deserializes and does anonymization/formatting for views
module PatientInvitationListHelper
  def fetch_patient_enrollments
    @enrollments = PatientEnrollment.by_study_and_study_site(params)
    @enrollments = @enrollments.sort_by { |e| e.created_at }.reverse
    @enrollments.each { |e| format_and_anonymize(e) }
  end
  
  def format_and_anonymize(enrollment)
    enrollment.email = anonymize_email(enrollment.email) unless enrollment.email.blank?
    enrollment.created_at = format_date(enrollment.created_at) unless enrollment.created_at.blank?
    enrollment.state = enrollment.state.capitalize unless enrollment.state.blank?
    enrollment
  end
  
  private
  def anonymize_email(email)
    user, domain = email.split("@")
    user = user.chars
    tld = domain.present? ? domain.split('.').from(1).join('.') : ''
    domain = (domain.present? ? domain.split('.').first : '').chars

    if user.length >= 2
      user = user.take(2).join << '*' * (user.length > 20 ? 18 : user.length - 2)
    else
      user = user.take(2).join << '***'
    end
    
    if domain.length >= 2
      domain = domain.take(2).join << '*' * (domain.length > 10 ? 8 : domain.length - 2)
    else
      domain = domain.take(2).join << '***'
    end
    
    "#{user}@#{domain}.#{tld}"
  end
  
  def format_date(date)
    Date.strptime(date).strftime('%d-%^b-%Y')
  end
end
