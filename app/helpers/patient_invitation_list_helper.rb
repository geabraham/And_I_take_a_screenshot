# Retrieves patient_enrollments from Subject service and calls anonymization/formatting methods for patient management grid
module PatientInvitationListHelper
  def fetch_patient_enrollments
    @enrollments = PatientEnrollment.by_study_and_study_site(params)
    @enrollments = @enrollments.sort_by { |e| e.created_at }.reverse
    @enrollments.each { |e| e.format_and_anonymize }
  end
end
