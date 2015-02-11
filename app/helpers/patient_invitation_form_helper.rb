module PatientInvitationFormHelper
  # Takes params from patient invitation form and returns the set of params needed for patient enrollment.
  #
  def clean_params_for_patient_enrollment(params = {})
    check_required_params!(params)
    patient_enrollment_params = params[:patient_enrollment]
    check_required_patient_enrollment_params!(patient_enrollment_params)

    replace_country_and_language(patient_enrollment_params)
    replace_subject(patient_enrollment_params)
    patient_enrollment_params.merge(enrollment_type: 'in-person', study_uuid: params[:study_uuid], study_site_uuid: params[:study_site_uuid])
  end

  private

  [:required_params, :required_patient_enrollment_params].each do |param_group|
    define_method("check_#{param_group.to_s}!") do |params|
      unless send(param_group).all? { |pg| params.include?(pg) }
        raise ArgumentError.new("Missing one or more #{param_group.to_s.gsub('_', ' ')}: #{send(param_group).join(', ')}.")
      end
    end
  end

  def required_params
    [:study_uuid, :study_site_uuid, :patient_enrollment]
  end

  def required_patient_enrollment_params
    [:country_language, :subject]
  end

  def replace_subject(patient_enrollment_params = {})
    subject_id = patient_enrollment_params.delete(:subject)
    patient_enrollment_params.merge!(subject_id: subject_id)
  end

  def replace_country_and_language(patient_enrollment_params = {})
    country_and_language = JSON.parse(patient_enrollment_params.delete(:country_language))
    country_code, language_code = country_and_language['country_code'], country_and_language['language_code']
    patient_enrollment_params.merge!({country_code: country_code, language_code: language_code})
  end
end
