# TODO: How to test for the inclusion of ActiveModel?
class PatientEnrollment
  include ActiveModel::Model
  attr_accessor :uuid, :login, :password, :security_question, :answer, :activation_code, :login_confirmation
end
