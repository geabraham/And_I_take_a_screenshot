require 'spec_helper'

describe PatientManagementController do
  describe 'GET available_subjects' do
    let(:verb)      { :get }
    let(:action)    { :available_subjects }
    let(:user_uuid) { '1f0e0d68-d679-4661-8689-b08311142ba0' }
    before do
      allow(CASClient::Frameworks::Rails::Filter).to receive(:filter).and_return(true)
      session[:cas_extra_attributes] = {
        user_email: 'testuser@gmail.com',
        user_uuid: user_uuid
      }.stringify_keys
    end

    context 'without study and study site parameters' do
      let(:params)            { {} }
      let(:expected_template) { 'error' }
      let(:expected_status_code) { 422 }

      it_behaves_like 'renders expected template'
      it_behaves_like 'returns expected status'
    end
  end
end