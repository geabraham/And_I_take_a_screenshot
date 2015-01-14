class PatientEnrollmentsController < ApplicationController
  layout "patient_registration"
  
  def new
    patient_enrollment_uuid = '75d4b499-4b5f-46de-828b-56a197dd5ecd' #session[:patient_enrollment_uuid]
    @patient_enrollment = PatientEnrollment.new(uuid: patient_enrollment_uuid)
    @tou_dpn_agreement_body = @patient_enrollment.tou_dpn_agreement_body
    @security_questions = RemoteSecurityQuestions.find_or_fetch(@patient_enrollment.language_code || I18n.default_locale).map { |sq| sq.values }
  rescue StandardError => e
    # TODO: render error modal
    return render json: {message: "Unable to continue with registration. Error: #{e.message}"}, status: 422
  end

  def create #TODO test this
    # TODO PATCH: /v1/patient_enrollments/:patient_enrollment_uuid/register
    
    render 'download'
  end
end
