require 'rails_helper'

describe PatientRegistrationsController do
  
  describe "GET 'index'" do
    it 'uses the patient_registration template' do
      get :index
      expect(response).to render_template("patient_registration")
    end
    
    it 'returns http success' do
      expect(response).to be_success
    end
  end
end
