class PatientEnrollmentsController < ApplicationController
  layout "patient_registration"
  
  def download
  end

  def new
    patient_enrollment_uuid = session[:patient_enrollment_uuid]
    binding.pry
    @patient_enrollment = PatientEnrollment.new(uuid: patient_enrollment_uuid)
    binding.pry
    @tou_dpn_agreement = @patient_enrollment.tou_dpn_agreement

    # NOTE: @security_questions has no test. It is, for now, faked.
    @security_questions = ["What's the worst band in the world?"]
  rescue StandardError => e
    # TODO: render error modal
    return render json: {message: "Unable to continue with registration. Error: #{e.message}"}, status: 422
  end
  
  def create #TODO test this
    # TODO PATCH: /v1/patient_enrollments/:patient_enrollment_uuid/register
    
    render 'download'
  end
end
