class PatientEnrollmentsController < ApplicationController
  layout "patient_registration"
  
  def new
    # NOTE: @security_questions has no test. It is, for now, faked.
    @security_questions = ["What's the worst band in the world?"]
    @patient_enrollment = PatientEnrollment.new
  end
  
  def create #TODO test this
    # TODO PATCH: /v1/patient_enrollments/:patient_enrollment_uuid/register
    
    #TODO at this point, we should determine whether a user is on a mobile browser
    #and if so, whether they have the app installed. HOW?
    #@speedbump_message = 'Open the Patient Cloud app?'
    
    #if app is not installed
    @speedbump_text = 'Download the Patient Cloud app from the app store?'
    @cancel_text = 'Cancel'
    @proceed_text = 'Open'
    
    render 'download'
  end
end
