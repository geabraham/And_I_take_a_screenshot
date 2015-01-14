require 'spec_helper'

describe PatientManagementController do
  describe 'select_study_and_site' do
    context 'when user is not logged in' do
      before do
        allow(CASClient::Frameworks::Rails::Filter).to receive(:filter).and_return(false)
      end

      it 'redirects to iMedidata' do
        get 'select_study_and_site'
        expect(response).to redirect_to("#{CAS_BASE_URL}/login?service=#{CGI.escape(request.original_url)}")
      end
    end

    context 'with user logged in' do
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
          # Note: The empty array represents imedidata user errors, which are not populated in specs because we are stubbing the response
          #   to #check_study_invitation!
          #
          {message: 'You are not authorized for patient management. []'}.to_json
        end

        it_behaves_like 'returns expected status'
        it_behaves_like 'returns expected error response body'
      end

      context 'when user is not authorized for patient management' do
        let(:study_group_uuid)     { SecureRandom.uuid }
        let(:params)               { {study_group_uuid: study_group_uuid, controller: 'patient_management', action: 'select_study_and_site'} }
        let(:expected_status_code) { 422 }
        let(:error_response_body)  do
          # Note: The empty array represents imedidata user errors, which are not populated in specs because we are stubbing the response
          #   to #check_study_invitation!
          #
          {message: 'You are not authorized for patient management. []'}.to_json
        end

        before do
          allow(imedidata_user).to receive(:check_study_invitation!).with(params).and_return(false)
          controller.instance_variable_set(:@imedidata_user, imedidata_user)
        end

        it_behaves_like 'returns expected status'
        it_behaves_like 'returns expected error response body'
      end

      context 'when user is authorized for patient management' do
        context 'with study group parameter' do
          let(:study_group_uuid)     { SecureRandom.uuid }
          let(:params)               { {study_group_uuid: study_group_uuid, controller: 'patient_management', action: 'select_study_and_site'} }
          let(:expected_status_code) { 200 }
          let(:expected_body)        { studies.to_json }
          let(:studies) do
            {studies: [{name: 'TesStudy001', uuid: SecureRandom.uuid}, {name: 'TestStudy002', uuid: SecureRandom.uuid}]}
          end

          before do
            allow(imedidata_user).to receive(:check_study_invitation!).with(params).and_return(true)
            allow(imedidata_user).to receive(:get_studies!).and_return(studies)
            controller.instance_variable_set(:@imedidata_user, imedidata_user)
          end

          it_behaves_like 'returns expected status'
          it_behaves_like 'returns expected body'
        end
      end

      context 'with study parameter' do
        let(:study_uuid)  { SecureRandom.uuid }
        let(:params)      { {study_uuid: study_uuid, controller: 'patient_management', action: 'select_study_and_site'} }
        let(:study_sites) { {study_sites: []} }

        before do
          allow(imedidata_user).to receive(:check_study_invitation!).with(params).and_return(true)
          allow(imedidata_user).to receive(:get_study_sites!).with(study_uuid).and_return(study_sites)
          controller.instance_variable_set(:@imedidata_user, imedidata_user)
        end

        it 'does not make a request for the studies for that user' do
          expect(imedidata_user).not_to receive(:get_studies!)
          get 'select_study_and_site', params
        end

        it 'makes a request for the sites for that study and user' do
          expect(imedidata_user).to receive(:get_study_sites!).with(study_uuid)
          get 'select_study_and_site', params
        end
      end
    end
  end
end