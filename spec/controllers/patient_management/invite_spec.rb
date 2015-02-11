require 'spec_helper'

describe PatientManagementController do
  describe 'POST invite' do
    let(:verb)   { :post }
    let(:action) { :invite }
    let(:study_uuid) { 'b11715eb-c63a-4bc6-9822-5565b61e27ba' }
    let(:study_site_uuid) { '9667f770-9391-4f2d-a759-a44033fff8bf' }
    let(:subject) { 'Subject-489' }
    let(:enrollment_type) { 'in-person' }
    let(:language_code) { 'eng' }
    let(:country_code) { 'US' }
    let(:params) do
      {
        study_site_uuid: study_site_uuid,
        study_uuid: study_uuid,
        patient_enrollment: {
          country_language: {language_code: language_code, country_code: country_code}.to_json,
          subject: subject,
          enrollment_type: enrollment_type
        }
      }
    end
    let(:user_uuid) { SecureRandom.uuid }
    let(:http_headers) { {http_headers: {'X-MWS-Impersonate' => user_uuid}} }

    before do
      allow(CASClient::Frameworks::Rails::Filter).to receive(:filter).and_return(true)
      session[:cas_extra_attributes] = {
        user_email: 'testuser@gmail.com',
        user_uuid: user_uuid
      }.stringify_keys
    end

    context 'when backend service is unavailable' do
      let(:expected_template) { 'error' }
      let(:params_for_patient_enrollment) do
        {
          patient_enrollment: {
            study_uuid: study_uuid,
            study_site_uuid: study_site_uuid,
            subject_id: subject,
            country_code: country_code,
            language_code: language_code,
            enrollment_type: enrollment_type
          }
        }
      end

      before do
        allow(Euresource::PatientEnrollment).to receive(:post!)
          .with(params_for_patient_enrollment, http_headers)
          .and_raise(Faraday::Error::ConnectionFailed.new('Cannot connect'))
      end

      it_behaves_like 'renders expected template'
      it_behaves_like 'assigns an ivar to its expected value', :status_code, 503
    end
  end
end
