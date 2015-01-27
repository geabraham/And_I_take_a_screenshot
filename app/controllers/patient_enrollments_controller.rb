class PatientEnrollmentsController < ApplicationController
  layout "patient_registration"
  
  def new
    patient_enrollment_uuid = session[:patient_enrollment_uuid]
    @patient_enrollment = PatientEnrollment.new(uuid: patient_enrollment_uuid)
    @tou_dpn_agreement_body = @patient_enrollment.tou_dpn_agreement_body
    @security_questions = RemoteSecurityQuestions.find_or_fetch(@patient_enrollment.language_code || I18n.default_locale).map { |sq| sq.values }
  rescue StandardError => e
    # TODO: render error modal
    return render json: {message: "Unable to continue with registration. Error: #{e.message}"}, status: 422
  end

  def register
    params.require(:patient_enrollment)
    patient_enrollment_params = params['patient_enrollment']
    required_register_params.each { |p| patient_enrollment_params.require(p) }

    # FIXME: May be simpler if this is security question id in the form.
    # Changing it was not simple so left as is for now.
    if security_question_id = patient_enrollment_params.delete('security_question')
      patient_enrollment_params['security_question_id'] = security_question_id
    end

    if new_user_params.any? {|p| patient_enrollment_params.include?(p) }
      new_user_params.each { |p| patient_enrollment_params.require(p) }
    end

    @register_params = patient_enrollment_params.permit(all_register_params)
      .merge(activation_code: session[:activation_code], tou_accepted_at: Time.now.to_s)

    register_response = Euresource::PatientEnrollments.invoke(:register, @register_params)

# params
# => {"utf8"=>"✓",
#  "authenticity_token"=>"Dme42wvkJzIw4dPL9mr0DYQCg8m46GlaoNRMgTANVEw=",
#  "patient_enrollment"=>
#   {"login"=>"a@g.com",
#    "login_confirmation"=>"a@g.com",
#    "password"=>"zaC!Tru3",
#    "password_confirmation"=>"zaC!Tru3",
#    "security_question"=>"2",
#    "answer"=>"hij"},
#  "commit"=>"Create account",
#  "action"=>"register",
#  "controller"=>"patient_enrollments"}
    #TODO test this
    # TODO PATCH: /v1/patient_enrollments/:patient_enrollment_uuid/register
    
    render 'download'
  end

  private

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
