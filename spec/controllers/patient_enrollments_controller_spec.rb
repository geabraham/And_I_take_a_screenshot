require 'spec_helper'

describe PatientEnrollmentsController do

  describe 'GET new' do
    context 'when a patient enrollment uuid is present' do
      let(:tou_dpn_agreement)       { 'Consider yourself warned.' }
      let(:patient_enrollment)      { double('PatientEnrollment') }
      let(:patient_enrollment_uuid) { SecureRandom.uuid }
      let(:params)                  { nil }
      before do
        session[:patient_enrollment_uuid] = patient_enrollment_uuid
        allow(PatientEnrollment).to receive(:new).with(uuid: patient_enrollment_uuid).and_return(patient_enrollment)
        allow(patient_enrollment).to receive(:tou_dpn_agreement).and_return(tou_dpn_agreement)
      end

      context 'when successful' do
        let(:verb)                 { :get }
        let(:action)               { :new }
        let(:expected_status_code) { 200 }
        let(:expected_template)    { 'patient_registration' }

        it_behaves_like 'returns expected status'
        it_behaves_like 'renders expected template'
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
