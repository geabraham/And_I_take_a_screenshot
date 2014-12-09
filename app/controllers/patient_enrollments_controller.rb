class PatientEnrollmentsController < ApplicationController
  layout "patient_registration"
  
  def download
  end

  def new
    patient_enrollment_uuid = params[:id].presence || SecureRandom.uuid
    tou_dpn_agreement_response = Euresource::PatientEnrollment.invoke(:tou_dpn_agreement, {uuid: '04b7207a-49ee-4b35-bd1c-cd35980cd865'})

    unless tou_dpn_agreement_response.status == 200
      raise "Error trying to retrieve TOU/DPN agreement. #{tou_dpn_agreement_response.status} Response: #{tou_dpn_agreement_response.body}"
    else
      if tou_dpn_agreement = JSON.parse(tou_dpn_agreement_response.body)
        @tou_dpn_agreement_html = tou_dpn_agreement['html']
      end
    end
    # TODO: Add Euresource integration here

    # NOTE: @security_questions has no test. It is, for now, faked.
    @security_questions = ["What's the worst band in the world?"]
    @patient_enrollment = PatientEnrollment.new
  end
  
  def create #TODO test this
    # TODO PATCH: /v1/patient_enrollments/:patient_enrollment_uuid/register
    
    render 'download'
  end
end
