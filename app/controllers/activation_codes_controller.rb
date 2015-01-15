class ActivationCodesController < ApplicationController
  layout "patient_registration"

  def index
  end

  def activate
    begin
      @activation_code = Euresource::ActivationCodes.get({activation_code: params[:id] })
      if @activation_code.attributes['state'] == 'active'
        session[:patient_enrollment_uuid] = @activation_code.attributes['patient_enrollment_uuid']
        session[:activation_code] = @activation_code.attributes['activation_code']
        head :ok
      # redirect_to controller: :patient_enrollments, action: :new
      else
        render json: "Activation Code must be in active state", status: 422
      end
    rescue Euresource::ResourceNotFound => e
      render json: e.message, status: 404
    end

  end
end
