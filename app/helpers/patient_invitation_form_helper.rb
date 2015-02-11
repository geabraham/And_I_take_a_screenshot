# TODO: Add spec(s)
#
module PatientInvitationFormHelper
  # Takes params from patient invitation form and returns the set of params needed for patient enrollment.
  #
  def clean_params_for_patient_enrollment(params = {})
    patient_enrollment_params = params.require(:patient_enrollment)
    replace_country_and_language(patient_enrollment_params)
    patient_enrollment_params.merge!(subject_params(params, patient_enrollment_params))
    patient_enrollment_params.merge(enrollment_type: 'in-person')
  end

  private

  def subject_params(params = {}, patient_enrollment_params = {})
    subject_id = patient_enrollment_params.delete(:subject)
    {study_uuid: params[:study_uuid], study_site_uuid: params[:study_site_uuid], subject_id: subject_id}
  end

  def replace_country_and_language(patient_enrollment_params = {})
    country_and_language = JSON.parse(patient_enrollment_params.delete('country_language'))
    country_code, language_code = country_and_language['country_code'], country_and_language['language_code']
    patient_enrollment_params.merge!({country_code: country_code, language_code: language_code})
  end
end
