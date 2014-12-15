require 'spec_helper'

describe PatientEnrollmentsController do
  let(:params) { nil }

  describe 'GET new' do
    let(:verb)              { :get }
    let(:action)            { :new }
    let(:expected_template) { 'patient_registration' }

    context 'when a patient enrollment uuid is present' do
      let(:tou_dpn_agreement)       { 'Consider yourself warned.' }
      let(:patient_enrollment)      { double('PatientEnrollment') }
      let(:patient_enrollment_uuid) { SecureRandom.uuid }

      before do
        session[:patient_enrollment_uuid] = patient_enrollment_uuid
        allow(PatientEnrollment).to receive(:new).with(uuid: patient_enrollment_uuid).and_return(patient_enrollment)
        allow(patient_enrollment).to receive(:tou_dpn_agreement).and_return(tou_dpn_agreement)
      end

      context 'when successful' do
        let(:expected_status_code) { 200 }

        it_behaves_like 'returns expected status'
        it_behaves_like 'renders expected template'
      end

      it 'assigns @tou_dpn_agreement_html' do
        get :new
        expect(assigns(:tou_dpn_agreement)).to eq(tou_dpn_agreement)
      end
    end

    context 'when no patient enrollment uuid is present in the request' do
      let(:expected_status_code) { 422 }
      it_behaves_like 'returns expected status'
    end
  end
  
  describe 'POST patient_enrollments' do
    context 'when successful' do
      let(:verb)                 { :post }
      let(:action)               { :create }
      let(:expected_status_code) { 200 }
      let(:expected_template)    { 'patient_registration' }

      it_behaves_like 'returns expected status'
      it_behaves_like 'renders expected template'
    end
  end
end
