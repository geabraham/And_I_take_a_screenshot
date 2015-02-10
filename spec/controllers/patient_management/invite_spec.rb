require 'spec_helper'

describe PatientManagementController do
  describe 'POST invite' do
    let(:verb)   { :post }
    let(:action) { :invite }
    let(:params) do
      {
        patient_enrollment: {
          language_code: 'eng',
          country_code: 'US',
          subject_id: '1',
          study_site_uuid: SecureRandom.uuid,
          study_uuid: SecureRandom.uuid,
          enrollment_type: 'in-person'
        }
      }.stringify_keys
    end
    let(:user_uuid) { SecureRandom.uuid }
    let(:patient_enrollment_headers) { {'MCC-Impersonate' => user_uuid}  }

    before do
      allow(CASClient::Frameworks::Rails::Filter).to receive(:filter).and_return(true)
      session[:cas_extra_attributes] = {
        user_email: 'testuser@gmail.com',
        user_uuid: user_uuid
      }.stringify_keys
    end

    context 'when backend service is unavailable' do
      let(:expected_template) { 'error' }
      before do
        allow(Euresource::PatientEnrollment).to receive(:post)
          .with(params, patient_enrollment_headers)
          .and_raise(Faraday::Error::ConnectionFailed.new('Cannot connect'))
      end

      it_behaves_like 'renders expected template'
      it_behaves_like 'assigns an ivar to its expected value', :status_code, 503
    end
  end
end
