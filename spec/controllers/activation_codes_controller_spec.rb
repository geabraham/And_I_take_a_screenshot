require 'rails_helper'

describe ActivationCodesController do
  
  describe "GET 'index'" do
    it 'uses the patient_registration template' do
      get :index
      expect(response).to render_template("patient_registration")
    end
    
    it 'returns http success' do
      expect(response).to be_success
    end
  end
  
  describe "POST 'activate'" do
    context 'when successful' do
      it 'sets a session variable of patient enrollment uuid' do
        post :activate, id: SecureRandom.hex(3)
        expect(session[:patient_enrollment_uuid]).to match(/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/)
      end

      it 'redirects to patient enrollments new' do
        post :activate, id: SecureRandom.hex(3)
        expect(subject).to redirect_to('/patient_enrollments/new')
      end
    end
  end
end
