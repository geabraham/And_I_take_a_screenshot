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
          let(:study1)               { {name: 'TestStudy001', uuid: SecureRandom.uuid} }
          let(:study2)               { {name: 'TestStudy002', uuid: SecureRandom.uuid} }
          let(:studies)              { {studies: [{name: study1[:name], uuid: study1[:uuid]}, {name: study2[:name], uuid: study2[:uuid]}]}.deep_stringify_keys }
          let(:expected_status_code) { 200 }
          let(:expected_ivars)       { [{name: 'study_or_studies', value: expected_ivar_value}] }
          let(:expected_ivar_value)  { [[study1[:name], study1[:uuid]], [study2[:name], study2[:uuid]]] }

          before do
            allow(controller).to receive(:request_studies!).with(params.merge(user_uuid: user_uuid)).and_return(studies)
          end

          it_behaves_like 'returns expected status'
          it_behaves_like 'assigns the expected instance variables'
        end
      end

      context 'with study parameter' do
        let(:study_uuid)           { SecureRandom.uuid }
        let(:params)               { default_params.merge(study_uuid: study_uuid) }
        let(:study_attributes)     { {name: 'Mediflex', uuid: study_uuid} }
        let(:study_response)       { {study: study_attributes}.deep_stringify_keys }
        let(:expected_status_code) { 200 }
        let(:expected_ivars)       { [{name: 'study_or_studies', value: expected_ivar_value}] }
        let(:expected_ivar_value)  { [[study_attributes[:name], study_attributes[:uuid]]] }

        before do
          allow(controller).to receive(:request_study!).with(params.merge(user_uuid: user_uuid)).and_return(study_response)
        end

        it_behaves_like 'returns expected status'
        it_behaves_like 'assigns the expected instance variables'
      end

      context 'with study and study site uuid parameters' do
        let(:study_uuid)        { SecureRandom.uuid }
        let(:study_site_uuid)   { SecureRandom.uuid }
        let(:params)            { default_params.merge(study_uuid: study_uuid, study_site_uuid: study_site_uuid) }
        let(:expected_template) { 'patient_management_grid' }

        it_behaves_like 'renders expected template'

        it 'requests tou dpn agreements'
        it 'requests subjects'

        context 'when tou dpn agreements request fails'
        context 'when subjects request fails'
        context 'when both tou dpn agreement request and subjects requests succed'
      end
    end
  end

  describe 'POST invite_patient' do
    context 'without all requried parameters'
    context 'with all required parameters'
  end
end
