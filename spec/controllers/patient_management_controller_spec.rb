require 'spec_helper'

describe PatientManagementController do
  before do
    # Create a provider who is authorized for Study X
  end

  describe 'select_study_and_site' do
    context 'when user is not logged in' do
      before do
        allow(CASClient::Frameworks::Rails::Filter).to receive(:filter).and_return(false)
      end

      it 'redirects to iMedidata' do
        get 'select_study_and_site'
        expect(response).to redirect_to("http://localhost:4567/login?service=http%3A%2F%2Ftest.host%2Fpatient_management")
      end
    end

    context 'with user logged in'
      let(:verb)                 { :get }
      let(:action)               { :select_study_and_site }
      let(:params)               { {} }
      let(:user_uuid)            { SecureRandom.uuid }
      let(:cas_extra_attributes) { {user_uuid: user_uuid}.stringify_keys! }
       
      before do
        allow(CASClient::Frameworks::Rails::Filter).to receive(:filter).and_return(true)
        session[:cas_extra_attributes] = cas_extra_attributes
      end

      context 'without study or study group parameter' do
        let(:expected_status_code) { 422 }
        let(:error_response_body)  do 
          {message: 'You are not authorized for patient management.'}.to_json
        end

        it_behaves_like 'returns expected status'
        it_behaves_like 'returns expected error response body'
      end

      context 'when user is not authorized for patient management' do
        let(:study_group_uuid) { SecureRandom.uuid }
        let(:params) { {study_group_uuid: study_group_uuid} }
        let(:expected_status_code) { 422 }
        let(:error_response_body)  do
          {message: 'You are not authorized for patient management.'}.to_json
        end
        before do
          allow_any_instance_of(IMedidataUser).to receive(:has_invitation?).with(params)
        end

        it_behaves_like 'returns expected status'
        it_behaves_like 'returns expected error response body'
      end

      context 'with study group parameter'
        it 'makes a roles request to iMedidata for the user for the study group'

        context 'when user is an authorized provider for the study group'
          it 'makes a request for the studies for that study group and user'

        context 'when user is not an authorized provider for the study group'
          it 'displays a helpful error message'

      context 'with study parameter'
        it 'makes a roles to iMedidata for the user for the study'

        context 'when user ia an authorized provider for the study'
          it 'makes a request for the sites for that study and user'

        context 'when user is not an authorized provider for the study'
          it 'displays a helpful error message'
  end
end