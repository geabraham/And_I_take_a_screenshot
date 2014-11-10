class ActivationCodesController < ApplicationController
  layout "patient_registration"
  
  def index
  end
  
  def activate
    head :ok
    
    #TODO call to subject service here
  end
end
