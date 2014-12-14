require 'spec_helper'

describe PatientEnrollmentsController do
  let(:params) { nil }
  let(:jpn_security_questions) do
    [{"name"=>"生まれた年を入力してください。", "id"=>"1"},
     {"name"=>"ソーシャルセキュリティ番号、納税者ID、健康保険証番号の下4桁は何ですか?", "id"=>"2"}]
  end
  before do
    allow(RemoteSecurityQuestions).to receive(:find_or_fetch).with(I18n.default_locale).and_return([{}])
    allow(RemoteSecurityQuestions).to receive(:find_or_fetch).with('jpn').and_return(jpn_security_questions)
  end
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
      let(:error_response_body)  do 
        {message: 'Unable to continue with registration. Error: Cannot request TOU/DPN agreement without attribute: uuid'}.to_json
      end

      it_behaves_like 'returns expected status'
      it_behaves_like 'returns expected error response body'
    end

    describe 'security questions' do
      it 'assigns @security_questions to a set of questions using the locale parameter' do
        get :new, locale: 'jpn'
        expect(assigns(:security_questions)).to eq(
          [["生まれた年を入力してください。", 1], ["ソーシャルセキュリティ番号、納税者ID、健康保険証番号の下4桁は何ですか?", 2]])
      end
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
