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
      let(:cas_extra_attributes) { {user_uuid: SecureRandom.uuid}.stringify_keys! }
      let(:imedidata_user)       { IMedidataUser.new(imedidata_user_uuid: cas_extra_attributes['user_uuid']) }
       
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
        let(:study_group_uuid)     { SecureRandom.uuid }
        let(:params)               { {study_group_uuid: study_group_uuid, controller: 'patient_management', action: 'select_study_and_site'}.stringify_keys }
        let(:expected_status_code) { 422 }
        let(:error_response_body)  do
          {message: 'You are not authorized for patient management.'}.to_json
        end

        before do
          allow(imedidata_user).to receive(:has_accepted_invitation?).with(params).and_return(false)
          controller.instance_variable_set(:@imedidata_user, imedidata_user)
        end

        it_behaves_like 'returns expected status'
        it_behaves_like 'returns expected error response body'
      end

      context 'when user is authorized for patient management'
        context 'with study group parameter'
          context 'when user has an invitation to the study group'
            it 'makes a request for the studies for that study group and user'

          context 'when user is not an authorized provider for the study group'
            it 'displays a helpful error message'

        context 'with study parameter'
          context 'when user has an invitation to the study'
            it 'makes a request for the studies for that study group and user'

          context 'when user is not an authorized provider for the study'
            it 'displays a helpful error message'
  end
end