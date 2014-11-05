require 'rspec'
require 'rails_helper'

RSpec.describe PatientRegistrationController do
  
  describe "GET 'index'" do
    it "returns http success" do
      expect(response).to be_success
    end
  end
end
