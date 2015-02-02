require 'spec_helper'

describe StudySitesController do
  describe 'GET index' do
    context 'when user is not logged in' do
      it 'redirects to iMedidata' do
        get :index
        expect(response).to redirect_to("#{CAS_BASE_URL}/login?service=#{CGI.escape(request.original_url)}")
      end
    end

    context 'with a user logged in' do
      let(:verb)                 { :get }
      let(:action)               { :index }
      let(:default_params)       { {controller: 'study_sites', action: 'index'} }
      let(:user_uuid)            { SecureRandom.uuid }

      before do
        allow(CASClient::Frameworks::Rails::Filter).to receive(:filter).and_return(true)
        session[:cas_extra_attributes] = {user_uuid: user_uuid}.stringify_keys!
      end

      context 'without study uuid parameter' do
        let(:expected_status_code) { 422 }
        let(:error_response_body)  { {errors: 'param is missing or the value is empty: study_uuid'}.to_json }
        let(:params)               { default_params }

        it_behaves_like 'returns expected status'
        it_behaves_like 'returns expected error response body'
      end

      context 'with study uuid parameter' do
        let(:study_uuid)           { SecureRandom.uuid }
        let(:params)               { default_params.merge(study_uuid: study_uuid) }
        let(:study)                { {study: {name: 'Mediflex', uuid: study_uuid}}.deep_stringify_keys }
        let(:study_site1)          { {name: 'TestStudySite001', uuid: SecureRandom.uuid} }
        let(:study_site2)          { {name: 'TestStudySite002', uuid: SecureRandom.uuid} }
        let(:study_sites)          { {study_sites: [{name: study_site1[:name], uuid: study_site1[:uuid]}, {name: study_site2[:name], uuid: study_site2[:uuid]}]}.deep_stringify_keys }
        let(:expected_status_code) { 200 }
        let(:expected_body)        { [[study_site1[:name], study_site1[:uuid]], [study_site2[:name], study_site2[:uuid]]].to_json }

        before do
          allow(controller).to receive(:request_study_sites!).with(params.merge(user_uuid: user_uuid)).and_return(study_sites)
        end

        it_behaves_like 'returns expected status'
        it_behaves_like 'returns expected body'
      end
    end
  end
end
