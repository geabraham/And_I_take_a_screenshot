require 'rails_helper'

describe PatientEnrollmentsController do

  describe 'GET new' do
    context 'when a patient enrollment uuid is present' do
      let(:tou_dpn_agreement)       { 'Consider yourself warned.' }
      let(:patient_enrollment)      { PatientEnrollment.new(uuid: patient_enrollment_uuid) }
      let(:patient_enrollment_uuid) { SecureRandom.uuid }

      before do
        session[:patient_enrollment_uuid] = patient_enrollment_uuid
        PatientEnrollment.any_instance.stub(:tou_dpn_agreement).and_return(tou_dpn_agreement)
      end

      it 'returns success' do
        get :new
        expect(response).to be_success
      end

      it 'uses the patient_registration template' do
        get :new
        expect(response).to render_template("patient_registration")
      end

      it 'assigns @enrollment to a new PatientEnrollment object' do
        get :new
        expect(assigns(:patient_enrollment)).to be_a(PatientEnrollment)
      end

      it 'creates a PatientEnrollment with the session uuid' do
        get :new
        expect(assigns(:patient_enrollment).uuid).to eq(patient_enrollment_uuid)
      end

      it 'assigns @tou_dpn_agreement_html' do
        get :new
        expect(assigns(:tou_dpn_agreement)).to eq(tou_dpn_agreement)
      end
    end

    context 'when no patient enrollment uuid is present in the request' do
      it 'returns an error' do
        get :new
        expect(response.status).to eq(422)
      end
    end
  end
  
  describe 'POST patient_enrollments' do
    it 'returns success' do
      post :create
      expect(response).to be_success
    end
    
    it 'uses the patient_registration template' do
      post :create
      expect(response).to render_template("patient_registration")
    end
  end
end
