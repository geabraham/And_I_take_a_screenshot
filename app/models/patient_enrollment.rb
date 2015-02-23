class PatientEnrollment
  include ActiveModel::Model
  attr_accessor :uuid, :login, :password, :security_question, :answer, :activation_code, :login_confirmation,
                :tou_dpn_agreement, :initials, :email, :enrollment_type, :study_uuid, :study_site_uuid,
                :subject_id, :state, :tou_accepted_at
  RIGHT_TO_LEFT_LANGUAGE_CODES = ['ara', 'heb']

  def self.by_study_and_study_site(study_uuid, study_site_uuid)
    raise ArgumentError.new('Required argument study_uuid is blank.') if study_uuid.blank?
    raise ArgumentError.new('Required argument study_site_uuid is blank.') if study_site_uuid.blank?

    response = Euresource::PatientEnrollments.get(:all, params: { study_uuid: study_uuid, study_site_uuid: study_site_uuid })

    if response.last_response.status == 200
      JSON.parse(response.last_response.body).map{ |pe_hash|  PatientEnrollment.new(pe_hash) }
    end

  rescue => e
    Rails.logger.error("Error retrieving patient enrollments: #{e.message}")
    raise
  end

  def tou_dpn_agreement_body
    Nokogiri::HTML(tou_dpn_agreement['html']).css('body').to_s.html_safe
  end

  # Language code is either assigned or retrieved from the TOU/DPN.
  # TODO: Can we drop the TOU/DPN retrieval? It should always match the TOU/DPN.
  #
  def language_code
    @language_code || tou_dpn_agreement['language_code']
  end

  def language_code=(value)
    @language_code = value
  end

  def tou_dpn_agreement
    @tou_dpn_agreement ||= remote_tou_dpn_agreement
  end

  def script_direction
    RIGHT_TO_LEFT_LANGUAGE_CODES.include?(language_code) ? 'rtl' : 'ltr'
  end

  private
  # Returns the body of the remote tou dpn agreement.
  # raises an error if there is no uuid present
  #
  def remote_tou_dpn_agreement
    validate_presence_of_attribute!(:uuid, 'Cannot request TOU/DPN agreement without attribute:')
    response = Euresource::PatientEnrollment.invoke(:tou_dpn_agreement, {uuid: uuid})
    response_body_or_raise!(response)
  end

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
