require 'spec_helper'

describe PatientManagementController do
  describe "GET 'select_study_and_site'" do
    context 'when user is not logged in' do
      it 'redirects to iMedidata' do
        get :select_study_and_site
        expect(response).to redirect_to("#{CAS_BASE_URL}/login?service=#{CGI.escape(request.original_url)}")
      end
    end

    context 'with user logged in' do
      let(:verb)                 { :get }
      let(:action)               { :select_study_and_site }
      let(:default_params)       { {controller: 'patient_management', action: 'select_study_and_site'} }
      let(:user_uuid)            { SecureRandom.uuid }

      before do
        allow(CASClient::Frameworks::Rails::Filter).to receive(:filter).and_return(true)
        session[:cas_extra_attributes] = {user_uuid: user_uuid}.stringify_keys!
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
          let(:study1_uuid)          { SecureRandom.uuid }
          let(:study1_name)          { 'TestStudy001' }
          let(:study2_uuid)          { SecureRandom.uuid }
          let(:study2_name)          { 'TestStudy002' }
          let(:studies)              { {studies: [{name: study1_name, uuid: study1_uuid}, {name: study2_name, uuid: study2_uuid}]}.deep_stringify_keys }
          let(:expected_ivar_name)   { 'study_or_studies' }
          let(:expected_ivar_value)  { [[study1_name, study1_uuid], [study2_name, study2_uuid]]}

          before do
            allow(controller).to receive(:request_studies!).with(params.merge(user_uuid: user_uuid)).and_return(studies)
          end

          it_behaves_like 'returns expected status'
          it_behaves_like 'assigns the expected instance variable'
        end
      end

      context 'with study parameter' do
        let(:study_uuid)           { SecureRandom.uuid }
        let(:params)               { default_params.merge(study_uuid: study_uuid) }
        let(:expected_status_code) { 200 }
        let(:study_site1_uuid)     { SecureRandom.uuid }
        let(:study_site1_name)     { 'TestStudySite001' }
        let(:study_site2_uuid)     { SecureRandom.uuid }
        let(:study_site2_name)     { 'TestStudySite002' }
        let(:study_sites)          { {study_sites: [{name: study_site1_name, uuid: study_site1_uuid}, {name: study_site2_name, uuid: study_site2_uuid}]}.deep_stringify_keys }
        let(:study)                { {study: {name: 'Mediflex', uuid: study_uuid}}.deep_stringify_keys }
        let(:expected_ivar_name)   { 'study_sites' }
        let(:expected_ivar_value)  { [[study_site1_name, study_site1_uuid], [study_site2_name, study_site2_uuid]]}

        before do
          allow(controller).to receive(:request_study!).with(params.merge(user_uuid: user_uuid)).and_return(study)
          allow(controller).to receive(:request_study_sites!).with(params.merge(user_uuid: user_uuid)).and_return(study_sites)
        end

        it_behaves_like 'returns expected status'
        it_behaves_like 'assigns the expected instance variable'
      end
    end
  end
end
