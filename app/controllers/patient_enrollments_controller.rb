class PatientEnrollmentsController < ApplicationController
  layout "patient_registration"
  
  def new
    # NOTE: @security_questions has no test. It is, for now, faked.
    @security_questions = ["What's the worst band in the world?"]
    @patient_enrollment = PatientEnrollment.new
  end
  
  def create #TODO test this
    # TODO PATCH: /v1/patient_enrollments/:patient_enrollment_uuid/register
    
    #TODO: verify that the user agent strings for Patient Cloud iOS/Android agree with this implementation
    if request.env['HTTP_USER_AGENT'].include?('Patient Cloud iOS')
      #link to an app URL defined by the iOS team
    elsif request.env['HTTP_USER_AGENT'].include?('Patient Cloud Android')
      #link to an app URL defined by the Android team
    else 
      @download_link = 'https://itunes.apple.com/us/app/patient-cloud/id554170114?mt=8'
    end
    
    render 'download'
  end
end
