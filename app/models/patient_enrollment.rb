class PatientEnrollment
  include ActiveModel::Model
  attr_accessor :uuid, :login, :password, :security_question, :answer, :activation_code, :login_confirmation
  define_model_callbacks :initializer, only: :after
  after_initializer :validate_presence_of_uuid

  def validate_presence_of_uuid
    raise ActiveModel::Errors.new("No uuid provided") unless self.uuid.present?
  end

  def tou_dpn_agreement_html
    tou_dpn_agreement['html']
  end

  private
  def tou_dpn_agreement
    response = Euresource::PatientEnrollment.invoke(:tou_dpn_agreement, {uuid: uuid})
    JSON.parse(response.body)
  end
end
