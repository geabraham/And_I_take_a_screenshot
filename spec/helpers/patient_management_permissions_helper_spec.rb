require 'spec_helper'

describe PatientManagementPermissionsHelper do
  describe '#check_study_and_study_site_permissions!' do
    let(:test_class) { Class.new { extend PatientManagementPermissionsHelper } }
    let(:user_uuid)  { '1fdb2e4c-2e9a-4b88-a657-519ae4a62cb5' }
    let(:params)     { {user_uuid: user_uuid} }
    let(:study1)     { {name: 'TestStudy001', uuid: 'be0040e9-b6c5-4ef5-a1fd-2095fb2634b2'} }
    let(:study2)     { {name: 'TestStudy002', uuid: '387501a5-5530-475c-9463-72239211431d'} }
    let(:studies)    { {studies: [study1, study2]}.deep_stringify_keys }

    before do
      allow(test_class).to receive(:params).and_return(params)
      allow(test_class).to receive(:request_studies!).with(params).and_return(studies)
    end

    context 'when no study or study site is present in the request' do
      it 'checks permissions for the user\'s studies' do
        expect(test_class).to receive(:request_studies!).with(params)
        test_class.check_study_and_study_site_permissions!
      end

      context 'when user has permissions' do
        it 'returns true' do
          expect(test_class.check_study_and_study_site_permissions!).to eq(true)
        end

        it 'assigns studies' do
          test_class.check_study_and_study_site_permissions!
          expect(test_class.instance_variable_get("@studies")).to eq(studies['studies'])
        end
      end

      context 'when user does not have permissions for patient management' do
        include IMedidataClient
        let(:error_status)   { 404 }
        let(:error_body)     { 'Not found' }
        let(:error_response) { double('error_response', status: error_status, body: error_body) }
        let(:client_error)   { imedidata_client_error('Studies', params, error_response) }
        before { allow(test_class).to receive(:request_studies!).with(params).and_raise(client_error) }

        it 'raises an error' do
          expect { test_class.check_study_and_study_site_permissions! }.to raise_error(client_error)
        end
      end
    end

    context 'when study uuid is present in the request' do
      let(:params) { {user_uuid: user_uuid, study_uuid: study1[:uuid]} }

      it 'checks permissions for the user\'s studies' do
        expect(test_class).to receive(:request_studies!).with(params)
        test_class.check_study_and_study_site_permissions!
      end

      context 'when user has permissions' do
        context 'when study uuid is in the list of users\'s studies' do        
          it 'returns true' do
            expect(test_class.check_study_and_study_site_permissions!).to eq(true)
          end

          it 'assigns studies' do
            test_class.check_study_and_study_site_permissions!
            expect(test_class.instance_variable_get("@studies")).to eq(studies['studies'])
          end

          it 'assigns study' do
            test_class.check_study_and_study_site_permissions!
            expect(test_class.instance_variable_get("@study")).to eq(study1.stringify_keys)
          end
        end

        context 'when study uuid is not in the user\'s studies' do
          let(:studies) { {studies: [{name: study2[:name], uuid: study2[:uuid]}]}.deep_stringify_keys }

          it 'raises a not found error' do
            expect do
              test_class.check_study_and_study_site_permissions!
            end.to raise_error(
              PatientManagementPermissionsHelper::PermissionsError,
              "No patient management permissions for user #{user_uuid} for study #{study1[:uuid]}")
          end
        end
      end

      context 'when user does not have permissions' do
        include IMedidataClient
        let(:error_status) { 404 }
        let(:error_body)   { 'Not found' }
        let(:error_response) do
          double('error_response').tap do |er|
            allow(er).to receive(:status).and_return(error_status)
            allow(er).to receive(:body).and_return(error_body)
          end
        end
        let(:client_error) { imedidata_client_error('Studies', params, error_response) }
        before { allow(test_class).to receive(:request_studies!).with(params).and_raise(client_error) }

        it 'raises an error' do
          expect { test_class.check_study_and_study_site_permissions! }.to raise_error(client_error)
        end
      end
    end

    context 'when study site is present in the request' do
      let(:study_site1_uuid) { '7fd784a8-32ce-40e2-a68a-0a9d4faa5b18' }
      let(:study_site2_uuid) { '811692e7-2981-4512-b46c-fda6fbcae119' }
      let(:study_site1)      { {uuid: study_site1_uuid, name: 'TestStudySite1'}.stringify_keys }
      let(:study_site2)      { {uuid: study_site2_uuid, name: 'TestStudySite2'}.stringify_keys }
      let(:study_sites)      { {'study_sites' => [study_site1, study_site2]} }
      let(:params)           { {user_uuid: user_uuid, study_uuid: study1[:uuid], study_site_uuid: study_site1_uuid} }

      before { allow(test_class).to receive(:request_study_sites!).with(params).and_return(study_sites) }

      it 'checks permissions for the user\'s study sites' do
        expect(test_class).to receive(:request_study_sites!).with(params)
        test_class.check_study_and_study_site_permissions!
      end

      it 'does not check permissions for the user\'s studies' do
        expect(test_class).not_to receive(:request_studies!).with(params)
        test_class.check_study_and_study_site_permissions!
      end

      context 'when user has permissions' do
        it 'returns true' do
          expect(test_class.check_study_and_study_site_permissions!).to eq(true)
        end

        it 'assigns study site' do
          test_class.check_study_and_study_site_permissions!
          expect(test_class.instance_variable_get("@study_site")).to eq(study_site1.stringify_keys)
        end
      end

      context 'when user does not have permissions' do
        include IMedidataClient
        let(:error_status) { 404 }
        let(:error_body)   { 'Not found' }
        let(:error_response) do
          double('error_response').tap do |er|
            allow(er).to receive(:status).and_return(error_status)
            allow(er).to receive(:body).and_return(error_body)
          end
        end
        let(:client_error) { imedidata_client_error('Study Sites', params, error_response) }
        before { allow(test_class).to receive(:request_study_sites!).with(params).and_raise(client_error) }

        it 'raises an error' do
          expect { test_class.check_study_and_study_site_permissions! }.to raise_error(client_error)
        end
      end
    end
  end
end
