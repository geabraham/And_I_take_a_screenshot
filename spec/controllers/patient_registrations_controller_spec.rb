require 'rails_helper'

describe PatientRegistrationsController do
  
  describe "GET 'index'" do
    it 'returns http success' do
      expect(response).to be_success
    end
  end
end
