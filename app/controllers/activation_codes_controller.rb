class ActivationCodesController < ApplicationController
  layout "patient_registration"
  
  def index
  end
  
  def activate
    session[:patient_enrollment_uuid] = '2592319a-d3fe-48ef-a5ef-2ed8aa4c87ca'
    redirect_to controller: :patient_enrollments, action: :new
    #TODO call to subject service here
  end
end
