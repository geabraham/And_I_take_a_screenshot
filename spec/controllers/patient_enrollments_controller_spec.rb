require 'rails_helper'

describe PatientEnrollmentsController do

  describe 'GET new' do
    it 'returns success' do
      get :new
      expect(response).to be_success
    end
    
    it 'uses the patient_registration template' do
      get :new
      expect(response).to render_template("patient_registration")
    end

    it 'assigns @enrollment to a new PatientEnrollment object' do
      stubbed_enrollment = double PatientEnrollment
      allow(PatientEnrollment).to receive(:new).and_return(stubbed_enrollment)

      get :new
      expect(assigns(:patient_enrollment)).to eq stubbed_enrollment
    end
  end

end
