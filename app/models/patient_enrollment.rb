class PatientEnrollment
  include ActiveModel::Model
  attr_accessor :uuid, :login, :password, :security_question, :answer, :activation_code, :login_confirmation,
                :tou_dpn_agreement, :initials, :email, :enrollment_type, :study_uuid, :study_site_uuid,
                :subject_id, :state, :tou_accepted_at, :created_at
  RIGHT_TO_LEFT_LANGUAGE_CODES = ['ara', 'heb']

  def self.by_study_and_study_site(options)
    raise ArgumentError.new('Argument must be a hash.') unless options.is_a?(Hash)
    [:study_uuid, :study_site_uuid, :user_uuid].each do |key|
      raise ArgumentError.new("Required argument #{key} is blank.") if options[key].blank?
    end

    response = Euresource::PatientEnrollments.get(:all, params: options.slice(:study_uuid, :study_site_uuid),
      http_headers: { 'X-MWS-Impersonate' => options[:user_uuid] })

    if response.last_response.status == 200
      JSON.parse(response.last_response.body).map{ |pe_hash| PatientEnrollment.new(pe_hash) }
    else
      raise EuresourceError.new(response.last_response.body)
    end

  rescue => e
    Rails.logger.error_with_data("Error retrieving patient enrollments: #{e.message}", options)
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
  
  # stars out emails and formats dates for provider grid display
  def grid_formatted
    { created_at: self.created_at.blank? ? '' : self.formatted_date,
      subject_id: self.subject_id,
      email: self.email.blank? ? '' : self.anonymized_email,
      initials: self.initials,
      activation_code: self.activation_code,
      state: self.state.blank? ? '' : self.state.capitalize }
  end
  
  # anonymizes emails and caps their length if they are long
  def anonymized_email
    unless self.email.blank?
      user, domain = self.email.split("@")
      user, domain, tld = if domain.present?
        domain = domain.split('.')
        [user.chars, domain.first.chars, domain.from(1).join('.')]
      else
        [user.chars, ''.chars, '']
      end
      
      if user.length >= 2
        user = user.take(2).join << '*' * (user.length > 20 ? 18 : user.length - 2)
      else
        user = user.take(2).join << '***'
      end
      
      if domain.length >= 2
        domain = domain.take(2).join << '*' * (domain.length > 10 ? 8 : domain.length - 2)
      else
        domain = domain.take(2).join << '***'
      end
      
      "#{user}@#{domain}.#{tld}"
    else
      ''
    end
  end
  
  # formats date for display in the patient management grid
  def formatted_date
    Date.strptime(self.created_at).strftime('%d-%^b-%Y')
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
