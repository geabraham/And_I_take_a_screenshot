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
    # session[:patient_enrollment_uuid] = @activation_code['patient_enrollment_uuid']
    # redirect_to controller: :patient_enrollments, action: :new

    head :ok
  end
end
