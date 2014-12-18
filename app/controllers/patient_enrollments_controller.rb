class PatientEnrollmentsController < ApplicationController
  layout "patient_registration"
  
  def new
    patient_enrollment_uuid = session[:patient_enrollment_uuid]
    @patient_enrollment = PatientEnrollment.new(uuid: patient_enrollment_uuid)
    @tou_dpn_agreement_body = @patient_enrollment.tou_dpn_agreement_body

    @security_questions = RemoteSecurityQuestions.find_or_fetch(@patient_enrollment.language_code || I18n.default_locale).map { |sq| sq.values }
  rescue StandardError => e
    # TODO: render error modal
    return render json: {message: "Unable to continue with registration. Error: #{e.message}"}, status: 422
  end

  def create #TODO test this
    # TODO PATCH: /v1/patient_enrollments/:patient_enrollment_uuid/register
    
    if request.env['HTTP_USER_AGENT'].include?('Patient Cloud iOS')
      #TODO link to an app URL defined by the iOS team
    elsif request.env['HTTP_USER_AGENT'].include?('Patient Cloud Android')
      #TODO link to an app URL defined by the Android team
    else 
      @download_link = 'https://itunes.apple.com/us/app/patient-cloud/id554170114?mt=8'
    end
    
    render 'download'
  end
end
