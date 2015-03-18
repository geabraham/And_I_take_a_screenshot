require 'spec_helper'

describe PatientManagementController do
  before { allow(Rails.logger).to receive(:info_with_data) }
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
          let(:expected_status_code) { error_status }
          let(:log_message_1_args)   { ["Checking study authorizations for patient management.", {params: params.merge('user_uuid' => user_uuid)}] }
          let(:expected_logs)        { [{log_method: :info_with_data, args: log_message_1_args}] }

          before do
            allow(controller).to receive(:request_studies!).with(default_params.merge(user_uuid: user_uuid))
              .and_raise(imedidata_client_error('Studies', default_params, error_response))
          end

          it_behaves_like 'returns expected status'
          it_behaves_like 'assigns an ivar to its expected value', :status_code, 404
          it_behaves_like 'logs the expected messages at the expected levels'
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
        let(:study_response)       { {studies: [study_attributes]}.deep_stringify_keys }
        let(:expected_status_code) { 200 }
        let(:expected_ivars)       { [{name: 'study_or_studies', value: expected_ivar_value}] }
        let(:expected_ivar_value)  { [[study_attributes[:name], study_attributes[:uuid]]] }

        before do
          allow(controller).to receive(:request_studies!).with(params.merge(user_uuid: user_uuid)).and_return(study_response)
        end

        it_behaves_like 'returns expected status'
        it_behaves_like 'assigns the expected instance variables'
      end

      context 'with study and study site uuid parameters' do
        let(:study_uuid)               { '291120c1-c2e3-497a-9b1c-fd60cb3211a7' }
        let(:study_site_uuid)          { '7fd784a8-32ce-40e2-a68a-0a9d4faa5b18' }
        let(:params)                   { default_params.merge(study_uuid: study_uuid, study_site_uuid: study_site_uuid) }
        let(:study_site1)              { {uuid: '811692e7-2981-4512-b46c-fda6fbcae119', name: 'TestStudySite1'}.stringify_keys }
        let(:study_site2)              { {uuid: study_site_uuid, name: 'TestStudySite2'}.stringify_keys }
        let(:study_sites_response)     { {'study_sites' => [study_site1, study_site2]} }
        let(:euresource_enrollments_params) do
          {
            params: { study_uuid: study_uuid, study_site_uuid: study_site_uuid },
            http_headers: { 'X-MWS-Impersonate' => user_uuid }
          }
        end

        before do
          allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_return([])
          allow(Euresource::Subject).to receive(:get).with(:all, {params: {
            study_uuid: study_uuid,
            study_site_uuid: study_site_uuid,
            available: true}}).and_return([])
          allow(Euresource::PatientEnrollments).to receive(:get).with(:all, euresource_enrollments_params).and_return([])
          session[:cas_extra_attributes] = {
            user_uuid: user_uuid,
            authorized_study_sites: [{name: 'TestSite', uuid: study_site_uuid}]
          }.stringify_keys!
          allow(controller).to receive(:request_study_sites!).and_return(study_sites_response)
        end

        describe 'failure cases' do
          context 'when user has not been authorized for the study and site' do
            let(:expected_template)  { 'error' }
            let(:params_with_user)   { params.merge(user_uuid: user_uuid).stringify_keys }
            let(:log_message_1_args) { ["Checking study site authorizations for patient management.", {params: params_with_user}] }
            let(:log_message_2_args) { ["No patient management permissions for user #{user_uuid} for study_site #{study_site_uuid}", {params: params_with_user}] }
            let(:expected_logs) do
              [{log_method: :info_with_data, args: log_message_1_args}, {log_method: :error_with_data, args: log_message_2_args}]
            end
            before do
              allow(controller).to receive(:request_study_sites!).and_return({study_sites: []}.stringify_keys)
              allow(controller).to receive(:studies_selection_list).and_return([])
            end

            it_behaves_like 'renders expected template'
            it_behaves_like 'logs the expected messages at the expected levels'
          end

          context 'when tou dpn agreements request returns okay with anything other than an array' do
            let(:log_message_2_args) { ["Received response for TouDpnAgreements request.", {tou_dpn_agreements_response: '""'}] }
            let(:expected_logs) do
              [{log_method: :info, args: ["Requesting TouDpnAgreements."]}, {log_method: :info_with_data, args: log_message_2_args}]
            end
            before { allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_return('') } 

            it_behaves_like 'assigns an ivar to its expected value', :tou_dpn_agreements, []
            it_behaves_like 'logs the expected messages at the expected levels'
          end

          context 'when subjects request returns okay with anything other than an array' do
            let(:subjects_available_params) { {study_uuid: study_uuid, study_site_uuid: study_site_uuid, available: true} }
            let(:log_message_1_args) { ["Requesting available subjects.", {subjects_available_params: subjects_available_params}] }
            let(:log_message_2_args) { ["Received response for available subjects request.", {available_subjects_response: ''.inspect}] }
            let(:expected_logs) do
              [{log_method: :info_with_data, args: log_message_1_args}, {log_method: :info_with_data, args: log_message_2_args}]
            end

            before do
              allow(Euresource::Subject).to receive(:get).with(:all, {params: subjects_available_params}).and_return('')
            end

            it_behaves_like 'assigns an ivar to its expected value', :available_subjects, []
            it_behaves_like 'logs the expected messages at the expected levels'
          end

          context 'when tou dpn agreements request fails' do
            let(:expected_template)    { 'error' }
            let(:expected_status_code) { 500 }
            before { allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_raise(StandardError.new('TouDpnAgreements not found')) }

            it_behaves_like 'returns expected status'
            it_behaves_like 'renders expected template'
            it_behaves_like 'assigns an ivar to its expected value', :status_code, 500
          end

          context 'when available subjects request fails' do
            let(:expected_template)    { 'patient_management_grid' }
            let(:expected_status_code) { 200 }
            let(:last_response)   { double 'last object', status: 200, body: [].to_json}
            let(:response_object) { double 'response object', last_response: last_response }

            before do
              allow(Euresource::Subject).to receive(:get)
                .with(:all, {params: {
                  study_uuid: study_uuid,
                  study_site_uuid: study_site_uuid,
                  available: true}})
                .and_raise(Euresource::ResourceNotFound.new('Failed.'))
              allow(Euresource::PatientEnrollments).to receive(:get).with(:all, euresource_enrollments_params).and_return(response_object)
            end

            it_behaves_like 'returns expected status'
            it_behaves_like 'renders expected template'
            it_behaves_like 'assigns an ivar to its expected value', :available_subjects, []
          end
        end

        context 'when both tou dpn agreement request and subjects requests succeed' do
          let(:tou_dpn_agreement1_attrs) { {language_code: 'eng', country_code: 'usa', country: 'United States', language: 'English', uuid: SecureRandom.uuid}.stringify_keys }
          let(:tou_dpn_agreement2_attrs) { {language_code: 'spa', country_code: 'usa', country: 'United States', language: 'Spanish', uuid: SecureRandom.uuid}.stringify_keys }
          let(:tou_dpn_agreement3_attrs) { {language_code: 'ara', country_code: 'ara', country: 'Israel', language: 'Arabic', uuid: SecureRandom.uuid}.stringify_keys }
          let(:tou_dpn_agreement1)       { double('agreement', attributes: tou_dpn_agreement1_attrs) }
          let(:tou_dpn_agreement2)       { double('agreement', attributes: tou_dpn_agreement2_attrs) }
          let(:tou_dpn_agreement3)       { double('agreement', attributes: tou_dpn_agreement3_attrs) }
          let(:tou_dpn_agreements)       { [tou_dpn_agreement1, tou_dpn_agreement2, tou_dpn_agreement3]}
          let(:subject1_attrs)           { {uuid: SecureRandom.uuid, subject_identifier: 'Subject001'}.stringify_keys }
          let(:subject2_attrs)           { {uuid: SecureRandom.uuid, subject_identifier: 'Subject002'}.stringify_keys }
          let(:subject1)                 { double('subject', attributes: subject1_attrs) }
          let(:subject2)                 { double('subject', attributes: subject2_attrs) }
          let(:subjects)                 { [subject1, subject2] }
          let(:expected_template)        { 'patient_management_grid' }
          let(:last_response)            { double 'last object', status: 200, body: [].to_json}
          let(:response_object)          { double 'response object', last_response: last_response }

          it_behaves_like 'renders expected template'

          before do
            allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_return(tou_dpn_agreements)
            allow(Euresource::Subject).to receive(:get).with(:all, {params: {
              study_uuid: study_uuid,
              study_site_uuid: study_site_uuid,
              available: true}}).and_return(subjects)
            allow(Euresource::PatientEnrollments).to receive(:get).with(:all, euresource_enrollments_params).and_return(response_object)
          end

          it_behaves_like 'assigns an ivar to its expected value', :tou_dpn_agreements, [
              ['Israel / Arabic', {language_code: 'ara', country_code: 'ara'}.to_json],
              ['United States / English', {language_code: 'eng', country_code: 'usa'}.to_json],
              ['United States / Spanish', {language_code: 'spa', country_code: 'usa'}.to_json]
            ]
          it_behaves_like 'assigns an ivar to its expected value', :available_subjects, [['Subject001','Subject001'], ['Subject002','Subject002']]
          it_behaves_like 'assigns an ivar to its expected value', :study_site_name, 'TestStudySite2'
        end
      end
    end
  end
end
