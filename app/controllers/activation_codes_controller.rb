class ActivationCodesController < ApplicationController
  layout "patient_registration"
  
  def index
  end
  
  def activate
    # TODO:
    # Make euresource request for activation code representation
    # @activation_code = Euresource::ActivationCode.get(params[:id]).body
    #
    # raise unless @activation_code['state'] == 'active'
    #
    session[:patient_enrollment_uuid] = '04b7207a-49ee-4b35-bd1c-cd35980cd865' #@activation_code['patient_enrollment_uuid']
    # redirect_to controller: :patient_enrollments, action: :new

    head :ok
  end
end
