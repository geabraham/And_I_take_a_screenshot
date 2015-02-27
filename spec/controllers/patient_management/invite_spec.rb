require 'spec_helper'

describe PatientManagementController do
  describe 'POST invite' do
    let(:verb)            { :post }
    let(:action)          { :invite }
    let(:study_uuid)      { 'b11715eb-c63a-4bc6-9822-5565b61e27ba' }
    let(:study_site_uuid) { '9667f770-9391-4f2d-a759-a44033fff8bf' }
    let(:subject)         { 'Subject-489' }
    let(:enrollment_type) { 'in-person' }
    let(:language_code)   { 'eng' }
    let(:country_code)    { 'US' }
    let(:user_uuid)       { SecureRandom.uuid }
    let(:http_headers)    { {http_headers: {'X-MWS-Impersonate' => user_uuid}} }
    let(:params) do
      {
        study_site_uuid: study_site_uuid,
        study_uuid: study_uuid,
        patient_enrollment: {
          country_language: {language_code: language_code, country_code: country_code}.to_json,
          subject: subject,
          enrollment_type: enrollment_type
        }
      }.stringify_keys
    end
    let(:params_for_patient_enrollment) do
      {
        patient_enrollment: {
          study_uuid: study_uuid,
          study_site_uuid: study_site_uuid,
          subject_id: subject,
          country_code: country_code,
          language_code: language_code,
          enrollment_type: enrollment_type
        }.stringify_keys
      }
    end

    before do
      allow(CASClient::Frameworks::Rails::Filter).to receive(:filter).and_return(true)
      session[:cas_extra_attributes] = {
        user_email: 'testuser@gmail.com',
        user_uuid: user_uuid
      }.stringify_keys
      mock_study_sites_request = IMedidataClient::StudySitesRequest.new(user_uuid: user_uuid, study_uuid: study_uuid)
      stub_request(:get, IMED_BASE_URL + mock_study_sites_request.path)
        .to_return(status: 200, body: {study_sites: [{name: 'StudySite001', uuid: study_site_uuid}]}.to_json)
    end

    context 'when backend service is unavailable' do
      let(:expected_body)        { I18n.t('error.status_503.message') }
      let(:expected_status_code) { 503 }
      let(:error)                { Faraday::Error::ConnectionFailed.new('Cannot connect.') }
      let(:log_message_args)     { ["Rescuing error during patient invitation.", {error: error.inspect}] }
      let(:expected_logs)        { [{log_method: :error_with_data, args: log_message_args}] }

      before do
        allow(Euresource::PatientEnrollment).to receive(:post!)
          .with(params_for_patient_enrollment, http_headers)
          .and_raise(error)
      end

      it_behaves_like 'returns expected body'
      it_behaves_like 'returns expected status'
      it_behaves_like 'logs the expected messages at the expected levels'

      context 'when Euresource::ServerError' do
        let(:error) { Euresource::ServerError.new('Cannot connect.') }

        it_behaves_like 'returns expected body'
        it_behaves_like 'returns expected status'
        it_behaves_like 'logs the expected messages at the expected levels'
      end
    end

    context 'when backend service raises an error' do
      let(:expected_body)        { 'Subject not available. Please try again.' }
      let(:expected_status_code) { 404 }
      let(:error)                { StandardError.new() }

      before do
        allow(Euresource::PatientEnrollment).to receive(:post!)
          .with(params_for_patient_enrollment, http_headers)
          .and_raise(error)
      end

      it_behaves_like 'returns expected body'
      it_behaves_like 'returns expected status'
    end

    context 'when response is anything other than a new patient enrollment' do
      let(:expected_body)        { 'Subject not available. Please try again.' }
      let(:expected_status_code) { 404 }
      before do
        allow(Euresource::PatientEnrollment).to receive(:post!)
          .with(params_for_patient_enrollment, http_headers)
          .and_return({body: 'Not found', status: 404})
      end

      it_behaves_like 'returns expected body'
      it_behaves_like 'returns expected status'
    end

    context 'when response is a success' do
      let(:returned_enrollment) do
              { uuid: "25c06a8b-47ed-4382-a44f-9b45ea87216a",
                initials: 'TD',
                email: 'the-dude@gmail.com',
                enrollment_type: 'in-person',
                activation_code: 'ABCDEF',
                language_code: 'eng',
                study_uuid: study_uuid,
                study_site_uuid: study_site_uuid,
                subject_id: 'Subject-001',
                state: 'invited',
                tou_accepted_at: nil,
                created_at: '2015-02-26 18:47:07 UTC' }
      end
      let(:presentable_enrollment) do
              { uuid: "25c06a8b-47ed-4382-a44f-9b45ea87216a",
                initials: 'TD',
                email: 'th******@gm***.com',
                enrollment_type: 'in-person',
                activation_code: 'ABCDEF',
                language_code: 'eng',
                study_uuid: study_uuid,
                study_site_uuid: study_site_uuid,
                subject_id: 'Subject-001',
                state: 'invited',
                tou_accepted_at: nil,
                created_at: '26-FEB-2015' }
      end
      let(:expected_body)        { presentable_enrollment.to_json  }
      let(:expected_status_code) { 201 }
      let(:last_response)        { double 'last object', body: returned_enrollment.to_json }
      let(:response_object)      { double 'response object', last_response: last_response }
      let(:all_params)           { params.merge(controller: 'patient_management', action: 'invite', user_uuid: user_uuid) }
      let(:log_message_1_args)   { ["Attempting to invite a new patient.", {params: all_params.deep_stringify_keys}] }
      let(:log_message_2_args)   { ["Received response for patient invitation request.", {invitation_response: response_object.inspect}] }
      let(:expected_logs) do
        [{log_method: :info_with_data, args: log_message_1_args}, {log_method: :info_with_data, args: log_message_2_args}]
      end
      
      before do
        allow(Rails.logger).to receive(:info_with_data)
        allow(Euresource::PatientEnrollment).to receive(:post!)
          .with(params_for_patient_enrollment, http_headers)
          .and_return(response_object)
        allow(response_object).to receive(:is_a?).with(Euresource::PatientEnrollment).and_return(true)
      end

      it_behaves_like 'returns expected body'
      it_behaves_like 'returns expected status'
      it_behaves_like 'logs the expected messages at the expected levels'
    end
  end
end
