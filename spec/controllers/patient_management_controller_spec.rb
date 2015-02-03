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
        let(:study_uuid)               { '291120c1-c2e3-497a-9b1c-fd60cb3211a7' }
        let(:study_site_uuid)          { '7fd784a8-32ce-40e2-a68a-0a9d4faa5b18' }
        let(:params)                   { default_params.merge(study_uuid: study_uuid, study_site_uuid: study_site_uuid) }
        let(:study_site1)              { {uuid: '811692e7-2981-4512-b46c-fda6fbcae119', name: 'TestStudySite1'}.stringify_keys }
        let(:study_site2)              { {uuid: study_site_uuid, name: 'TestStudySite2'}.stringify_keys }
        let(:study_sites_response)     { {'study_sites' => [study_site1, study_site2]} }

        before do
          allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_return([])
          allow(Euresource::Subject).to receive(:get).with(:all, {params: {
            study_uuid: study_uuid,
            study_site_uuid: study_site_uuid,
            available: true}}).and_return([])
          session[:cas_extra_attributes] = {
            user_uuid: user_uuid,
            authorized_study_sites: [{name: 'TestSite', uuid: study_site_uuid}]
          }.stringify_keys!
          allow(controller).to receive(:request_study_sites!).and_return(study_sites_response)
        end

        describe 'failure cases' do
          before { get :select_study_and_site, params }

          context 'when user has not been authorized for the study and site' do
            let(:expected_template) { 'select_study_and_site' }
            before do
              allow(controller).to receive(:request_study_sites!).and_return([])
              allow(controller).to receive(:studies_selection_list).and_return([])
            end
            it_behaves_like 'renders expected template'
          end

          context 'when tou dpn agreements request returns okay with anything other than an array' do
            before { allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_return('') } 
            it_behaves_like 'assigns an ivar to its expected value', :tou_dpn_agreements, []
          end

          context 'when subjects request returns okay with anything other than an array' do
            before do
              allow(Euresource::Subject).to receive(:get).with(:all, {params: {
                study_uuid: study_uuid,
                study_site_uuid: study_site_uuid,
                available: true}}).and_return('')
            end
            it_behaves_like 'assigns an ivar to its expected value', :available_subjects, []
          end

          context 'when tou dpn agreements request fails' do
            let(:expected_status_code) { 422 }
            let(:error_response_body)  { {errors: 'TouDpnAgreements not found'}.to_json }
            before { allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_raise(StandardError.new('TouDpnAgreements not found')) }

            it_behaves_like 'returns expected status'
            it_behaves_like 'returns expected error response body'
          end

          context 'when available subjects request fails' do
            let(:expected_status_code) { 404 }
            let(:error_response_body)  { {errors: 'Failed.'}.to_json }
            before do
              allow(Euresource::Subject).to receive(:get)
                .with(:all, {params: {
                  study_uuid: study_uuid,
                  study_site_uuid: study_site_uuid,
                  available: true}})
                .and_raise(Euresource::ResourceNotFound.new('Failed.'))
            end

            it_behaves_like 'returns expected status'
            it_behaves_like 'returns expected error response body'
          end
        end

        context 'when both tou dpn agreement request and subjects requests succeed' do
          let(:tou_dpn_agreement1_attrs) { {language_code: 'ara', country_code: 'ara', country: 'Israel', language: 'Arabic', uuid: SecureRandom.uuid}.stringify_keys }
          let(:tou_dpn_agreement2_attrs) { {language_code: 'cze', country_code: 'cze', country: 'Czech Republic', language: 'Czech', uuid: SecureRandom.uuid}.stringify_keys }
          let(:tou_dpn_agreement1) do
            double('agreement').tap {|a| allow(a).to receive(:attributes).and_return(tou_dpn_agreement1_attrs)}
          end
          let(:tou_dpn_agreement2) do
            double('agreement').tap {|a| allow(a).to receive(:attributes).and_return(tou_dpn_agreement2_attrs)}
          end
          let(:tou_dpn_agreements) { [tou_dpn_agreement1, tou_dpn_agreement2]}
          let(:subject1_attrs) { {uuid: SecureRandom.uuid, subject_identifier: 'Subject001'}.stringify_keys }
          let(:subject2_attrs) { {uuid: SecureRandom.uuid, subject_identifier: 'Subject002'}.stringify_keys }
          let(:subject1) { double('subject').tap {|s| allow(s).to receive(:attributes).and_return(subject1_attrs)} }
          let(:subject2) { double('subject').tap {|s| allow(s).to receive(:attributes).and_return(subject2_attrs)} }
          let(:subjects) { [subject1, subject2] }
          let(:expected_template)        { 'patient_management_grid' }

          it_behaves_like 'renders expected template'

          before do
            allow(Euresource::TouDpnAgreement).to receive(:get).with(:all).and_return(tou_dpn_agreements)
            allow(Euresource::Subject).to receive(:get).with(:all, {params: {
              study_uuid: study_uuid,
              study_site_uuid: study_site_uuid,
              available: true}}).and_return(subjects)
            get :select_study_and_site, params
          end

          it_behaves_like 'assigns an ivar to its expected value', :tou_dpn_agreements, [
              ['Israel / Arabic', {language_code: 'ara', country_code: 'ara'}.to_json],
              ['Czech Republic / Czech', {language_code: 'cze', country_code: 'cze'}.to_json]
            ]
          it_behaves_like 'assigns an ivar to its expected value', :available_subjects, [['Subject001','Subject001'], ['Subject002','Subject002']]
          it_behaves_like 'assigns an ivar to its expected value', :study_site_name, 'TestStudySite2'
        end
      end
    end
  end
end
