class PatientEnrollment
  include ActiveModel::Model
  attr_accessor :uuid, :login, :password, :security_question, :answer, :activation_code, :login_confirmation

  def tou_dpn_agreement_html
    remote_tou_dpn_agreement['html']
  end

  # Returns the body of the remote tou dpn agreement.
  # raises an error if there is no uuid present
  #
  def remote_tou_dpn_agreement
    validate_presence_of_attribute!(:uuid, 'Cannot request TOU/DPN agreement without attribute:')
    response = Euresource::PatientEnrollment.invoke(:tou_dpn_agreement, {uuid: uuid})
    response_body_or_raise!(response)
  end

  private

  # Takes a attribute argument and validates the attribute as being present or raises an error.
  #
  def validate_presence_of_attribute!(attribute, message = 'Presence validation failed for attribute:')
    unless self.send(attribute).present?
      raise PatientEnrollmentError.new("#{message} #{attribute}")
    end
  end

  # Takes a response object argument.
  #   If response is successful, returns body of the response object
  #   otherwise raises an error with the response status and body.
  #
  def response_body_or_raise!(response)
    if response.status == 200
      JSON.parse(response.body)
    else
      raise RemotePatientEnrollmentError.new("Received unexpected response for tou_dpn_agreement. " <<
        "Response status: #{response.status}. Response body: #{response.body}")
    end
  end

  class PatientEnrollmentError < StandardError; end
  class RemotePatientEnrollmentError < StandardError; end
end
