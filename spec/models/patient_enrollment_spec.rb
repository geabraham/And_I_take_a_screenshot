require 'rails_helper'

describe PatientEnrollment do
  describe 'accessors' do
    it_behaves_like 'includes ActiveModel::Model', [:uuid, :login, :password, :security_question, :answer, :activation_code,
      :login_confirmation ]
  end
end
