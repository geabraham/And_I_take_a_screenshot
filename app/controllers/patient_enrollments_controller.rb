class PatientEnrollmentsController < ApplicationController
  layout "patient_registration"

  def new
    @patient_enrollment_uuid = SecureRandom.uuid
    @patient_enrollment = PatientEnrollment.new(uuid: @patient_enrollment_uuid)

    @tou_dpn_agreement_body = Nokogiri::HTML(File.read('config/tou_dpn_agreement.html')).css('body').to_s.html_safe
    @script_direction = 'rtl'
    @security_questions = [['In what year were you born?', 1], ['What was the make of your first car or bike?', 2]]

  rescue StandardError => e
    # TODO: render error modal
    return render json: {message: "Unable to continue with registration. Error: #{e.message}"}, status: 422
  end

  def register
    unless session[:patient_enrollment_uuid] && session[:activation_code]
      redirect_to activation_codes_path and return
    end

    register_response = Euresource::PatientEnrollments.invoke(
      :register,
      {uuid: session[:patient_enrollment_uuid]},
      {patient_enrollment: clean_registration_params})

    if register_response.status == 200
      render 'download'
      reset_session
    else
      render json: {errors: "Unable to complete registration: #{register_response.body}"}, status: register_response.status
    end
  end

  private

  # Returns cleaned registration params or responds 422 per strong parameters.
  #   Example: {login: 'cdr-adama@gmail.com', password: 'ejolmos', activation_code: 'HX6PKN', tou_accepted_at: ... }
  #
  def clean_registration_params
    params.require(:patient_enrollment)
    patient_enrollment_params = params['patient_enrollment']
    required_register_params.each { |p| patient_enrollment_params.require(p) }

    replace_security_question_key(patient_enrollment_params)

    if new_user_params.any? {|p| patient_enrollment_params.include?(p) }
      new_user_params.each { |p| patient_enrollment_params.require(p) }
    end

    patient_enrollment_params.permit(all_register_params)
      .merge(activation_code: session[:activation_code], tou_accepted_at: Time.now.to_s)
  end

  # Replaces 'security_question' with 'security_question_id'
  #
  def replace_security_question_key(params)
    unless params['security_question_id'].present?
      if security_question_id = params.delete('security_question')
        params['security_question_id'] = security_question_id
      end
    end
  end

  def all_register_params
    required_register_params + new_user_params
  end

  def required_register_params
    ['login', 'password']
  end

  def new_user_params
    ['security_question_id', 'answer']
  end
end
