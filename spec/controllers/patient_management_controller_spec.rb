require 'spec_helper'

describe PatientManagementController do
  describe 'select_study_and_site' do
    context 'when user is not logged in' do
      it 'redirects to iMedidata' do
        get 'select_study_and_site'
        expect(response).to redirect_to("#{CAS_BASE_URL}/login?service=#{CGI.escape(request.original_url)}")
      end
    end

    context 'with user logged in' do
      let(:verb)                 { :get }
      let(:action)               { :select_study_and_site }
      let(:default_params)       { {controller: 'patient_management', action: 'select_study_and_site'} }
      let(:user_uuid)            { SecureRandom.uuid }
      let(:cas_extra_attributes) { {user_uuid: user_uuid}.stringify_keys! }

      before do
        allow(CASClient::Frameworks::Rails::Filter).to receive(:filter).and_return(true)
        session[:cas_extra_attributes] = cas_extra_attributes
      end

      context 'without study parameter' do
        context 'when user has no studies for patient management' do
          include IMedidataClient
          let(:error_status) { 404 }
          let(:error_body)   { 'Not found' }
          let(:error_response) do
            double('error_response').tap do |er|
              allow(er).to receive(:status).and_return(error_status)
              allow(er).to receive(:body).and_return(error_body)
            end
          end
          let(:params)               { default_params }
          let(:expected_status_code) { 401 }
          let(:error_response_body) do
            {errors: 
              "You are not authorized for patient management. " <<
              "Studies request failed for #{default_params}. Response: #{error_status} #{error_body}"
            }.to_json
          end

          before do
            allow(controller).to receive(:request_studies!).with(default_params.merge(user_uuid: user_uuid))
              .and_raise(imedidata_client_error('Studies', default_params, error_response))
          end

          it_behaves_like 'returns expected status'
          it_behaves_like 'returns expected error response body'
        end

        context 'when user has studies for patient management' do
          let(:study_group_uuid)     { SecureRandom.uuid }
          let(:params)               { default_params.merge(study_group_uuid: study_group_uuid) }
          let(:expected_status_code) { 200 }
          let(:expected_body)        { studies.to_json }
          let(:studies) do
            {studies: [{name: 'TesStudy001', uuid: SecureRandom.uuid}, {name: 'TestStudy002', uuid: SecureRandom.uuid}]}
          end

          before do
            allow(controller).to receive(:request_studies!).with(params.merge(user_uuid: user_uuid)).and_return(studies)
          end

          it_behaves_like 'returns expected status'
          it_behaves_like 'returns expected body'
        end
      end

      context 'with study parameter' do
        let(:study_uuid)  { SecureRandom.uuid }
        let(:params)      { default_params.merge(study_uuid: study_uuid) }
        let(:study_sites) { {study_sites: []} }

        before do
          allow(controller).to receive(:request_study_sites!).with(params.merge(user_uuid: user_uuid)).and_return(study_sites)
        end

        it 'does not make a request for the studies for that user' do
          expect(controller).not_to receive(:request_studies!)
          get 'select_study_and_site', params
        end

        it 'makes a request for the sites for that study and user' do
          expect(controller).to receive(:request_study_sites!).with(params.merge(user_uuid: user_uuid))
          get 'select_study_and_site', params
        end
      end
    end
  end
end
