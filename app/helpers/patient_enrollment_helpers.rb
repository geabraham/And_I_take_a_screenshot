module PatientEnrollmentHelpers
  def params_for_subject(params = {})
    subject_params = params.slice(*required_subject_params)
    missing_params = required_subject_params.keep_if {|rsp| !subject_params.include?(rsp) }
    if missing_params.present?
      plural = missing_params.length > 1 ? true : false
      raise ArgumentError.new("Required param#{'s' if plural} #{missing_params.join(', ')} #{plural ? 'are' : 'is'} missing.")
    end
    subject_params[:subject_id] = subject_params.delete(:subject)
    subject_params
  end

  private

  def required_subject_params
    [:subject, :study_uuid, :study_site_uuid]
  end
end