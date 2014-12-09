class PatientEnrollmentsController < ApplicationController
  layout "patient_registration"
  
  def download
  end

  def new
    patient_enrollment_uuid = session[:patient_enrollment_uuid]
    @patient_enrollment = PatientEnrollment.new(uuid: patient_enrollment_uuid)
    @tou_dpn_agreement_html = @patient_enrollment.tou_dpn_agreement_html

    # NOTE: @security_questions has no test. It is, for now, faked.
    @security_questions = ["What's the worst band in the world?"]
  rescue StandardError => e
    return render json: {message: 'Unable to continue'}, status: 422
  end
  
  def create #TODO test this
    # TODO PATCH: /v1/patient_enrollments/:patient_enrollment_uuid/register
    
    render 'download'
  end
end
