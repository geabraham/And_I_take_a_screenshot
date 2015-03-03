require 'spec_helper'

describe PatientEnrollment do
  let(:patient_enrollment_uuid) { '34e147aa-c45d-4dc2-a434-786cca464cc7' }

  describe 'accessors' do
    it_behaves_like 'includes ActiveModel::Model', [:uuid, :login, :password, :security_question, :answer, :activation_code,
      :login_confirmation, :initials, :email, :enrollment_type, :activation_code, :language_code, :study_uuid, :study_site_uuid,
      :subject_id, :state, :tou_accepted_at, :created_at]
  end

  describe '#by_study_and_study_site' do
    let(:study_uuid)      { 'fc3d182b-5a9d-43bb-a8ee-bb2c132805e9' }
    let(:study_site_uuid) { '1e05f961-040b-40a3-a714-fec78efd9b14' }
    let(:user_uuid)       { '9d9f7a6c-ab23-43b9-a2ae-fc997752e48b' }

    before { allow(Rails.logger).to receive(:info) }

    context 'when argument is not a hash' do
      let(:args) { 'abc' }

      it 'logs the error' do
        expect(Rails.logger).to receive(:error_with_data)
          .with('Error retrieving patient enrollments: Argument must be a hash.', args)
        PatientEnrollment.by_study_and_study_site(args) rescue nil
      end

      it 'raises an error' do
        expect { PatientEnrollment.by_study_and_study_site(args) }.to raise_error(ArgumentError, 'Argument must be a hash.')
      end
    end

    context 'when study_uuid is blank' do
      let(:args) { { study_uuid: '', study_site_uuid: study_site_uuid, user_uuid: user_uuid } }

      it 'logs the error' do
        expect(Rails.logger).to receive(:error_with_data)
          .with('Error retrieving patient enrollments: Required argument study_uuid is blank.', args)
        PatientEnrollment.by_study_and_study_site(args) rescue nil
      end

      it 'raises an error' do
        expect { PatientEnrollment.by_study_and_study_site(args) }
          .to raise_error(ArgumentError, 'Required argument study_uuid is blank.')
      end
    end

    context 'when study_site_uuid is blank' do
      let(:args) { { study_uuid: study_uuid, study_site_uuid: '', user_uuid: user_uuid } }

      it 'logs the error' do
        expect(Rails.logger).to receive(:error_with_data)
          .with('Error retrieving patient enrollments: Required argument study_site_uuid is blank.', args)
        PatientEnrollment.by_study_and_study_site(args) rescue nil
      end

      it 'raises an error' do
        expect { PatientEnrollment.by_study_and_study_site(args) }
          .to raise_error(ArgumentError, 'Required argument study_site_uuid is blank.')
      end
    end

    context 'when user_uuid is blank' do
      let(:args) { { study_uuid: study_uuid, study_site_uuid: study_site_uuid, user_uuid: ''} }

      it 'logs the error' do
        expect(Rails.logger).to receive(:error_with_data)
          .with('Error retrieving patient enrollments: Required argument user_uuid is blank.', args)
        PatientEnrollment.by_study_and_study_site(args) rescue nil
      end

      it 'raises an error' do
        expect { PatientEnrollment.by_study_and_study_site(args) }
          .to raise_error(ArgumentError, 'Required argument user_uuid is blank.')
      end
    end

    context 'when required parameters are provided' do
      let(:args)            { { study_uuid: study_uuid, study_site_uuid: study_site_uuid, user_uuid: user_uuid } }
      let(:last_response)   { double 'last object', status: response_status, body: response_body}
      let(:response_object) { double 'response object', last_response: last_response }
      let(:euresource_params) do
        {
          params: { study_uuid: study_uuid, study_site_uuid: study_site_uuid },
          http_headers: { 'X-MWS-Impersonate' => user_uuid }
        }
      end

      context 'when Euresource encounters an error' do
        let(:exception) { StandardError.new('Test error') }
        before do
          allow(Rails.logger).to receive(:error_with_data)
          allow(Euresource::PatientEnrollments).to receive(:get) { raise exception }
        end

        it 'logs the error' do
          PatientEnrollment.by_study_and_study_site(args) rescue nil
          expect(Rails.logger).to have_received(:error_with_data)
            .with 'Error retrieving patient enrollments: Test error', args
        end

        it 'raises the error' do
          expect { PatientEnrollment.by_study_and_study_site(args) }.to raise_error(exception)
        end
      end

      context 'when Euresource returns a non-200 status' do
        let(:response_body)   { 'Test error message' }
        let(:response_status) { 404 }

        before do
          allow(Rails.logger).to receive(:error_with_data)
          allow(Euresource::PatientEnrollments).to receive(:get).with(:all, euresource_params).and_return(response_object)
        end

        it 'logs the error' do
          PatientEnrollment.by_study_and_study_site(args) rescue nil
          expect(Rails.logger).to have_received(:error_with_data)
            .with 'Error retrieving patient enrollments: Test error message', args
        end

        it 'raises a EuresourceError with an appropriate message' do
          expect { PatientEnrollment.by_study_and_study_site(args) }
            .to raise_error(EuresourceError, 'Test error message')
        end

      end

      context 'when Euresource successfully returns 0 enrollments' do
        let(:response_body)   { [].to_json }
        let(:response_status) { 200 }

        before do
          allow(Euresource::PatientEnrollments).to receive(:get)
            .with(:all, euresource_params)
            .and_return(response_object)
        end

        it 'returns an empty array' do
          expect(PatientEnrollment.by_study_and_study_site(args)).to eq []
        end
      end

      context 'when Euresource returns 1 or more patient enrollments' do
        let(:attribute_list) do
          [:uuid, :initials, :email, :enrollment_type, :activation_code, :language_code, :study_uuid, :study_site_uuid,
           :subject_id, :state, :tou_accepted_at, :created_at]
        end
        let(:patient_enrollment) do
          build :patient_enrollment,
                uuid: "25c06a8b-47ed-4382-a44f-9b45ea87216a",
                initials: 'TD',
                email: 'the-dude@gmail.com',
                enrollment_type: 'in-person',
                activation_code: 'ABCDEFG',
                language_code: 'eng',
                study_uuid: study_uuid,
                study_site_uuid: study_site_uuid,
                subject_id: 'Subject-001',
                state: 'invited',
                tou_accepted_at: nil,
                created_at: '2015-02-26 18:47:07 UTC'
        end
        let(:patient_enrollment_2) do
          build :patient_enrollment,
                uuid: "e52d1c1f-3482-4849-94b0-5dd7e2ce5b4f",
                initials: 'WS',
                email: 'walter.sobchak@gmail.com',
                enrollment_type: 'in-person',
                activation_code: '123456',
                language_code: 'eng',
                study_uuid: study_uuid,
                study_site_uuid: study_site_uuid,
                subject_id: 'Subject-002',
                state: 'registered',
                tou_accepted_at: Time.now.to_s,
                created_at: '2015-02-26 18:49:30 UTC'
        end
        let(:patient_enrollments) { [patient_enrollment, patient_enrollment_2] }
        let(:response_body)       { patient_enrollments.each{ |pe| Hash[attribute_list.zip(attribute_list.map{ |a| pe.send(a) } )] }.to_json }
        let(:response_status)     { 200 }

        before do
          allow(Euresource::PatientEnrollments).to receive(:get)
            .with(:all, euresource_params)
            .and_return(response_object)
        end

        # TODO: Does this adequately test?
        it 'returns an array of PatientEnrollment objects derived from the Euresource response body' do
          array = PatientEnrollment.by_study_and_study_site(args)
          response_array = JSON.parse(response_body)

          array.each do |pe|
            item_in_body = response_array.select{ |item| item['uuid'] == pe.uuid }.first.with_indifferent_access

            item_in_body.each do |attribute, value|
              expect(pe.send(attribute)).to eq value
            end
          end

          expect(array.count).to eq response_array.count
        end
      end
    end
  end


  describe 'instance methods' do
    include_context 'Euresource::PatientEnrollment#tou_dpn_agreement response'
    let(:tou_dpn_agreement_body)     { "<body><p>Maybe Christmas, the Grinch thought, doesn't come from a store.</p></body>" }
    let(:tou_dpn_agreement_html)     { "<html>#{tou_dpn_agreement_body}</html>"}
    let(:euresource_response_status) { 200 }
    let(:euresource_response_body)   { {html: tou_dpn_agreement_html, language_code: 'jpn'}.to_json }
    describe 'tou_dpn_agreement_body' do
      context 'when remote_tou_dpn_agreement exists' do
        it 'returns the body' do
          expect(PatientEnrollment.new(uuid: patient_enrollment_uuid).tou_dpn_agreement_body).to eq(tou_dpn_agreement_body)
        end
      end

      context 'when no uuid provided' do
        it 'raises an error' do
          expect {
            PatientEnrollment.new.send(:tou_dpn_agreement)
          }.to raise_error(PatientEnrollment::PatientEnrollmentError, 'Cannot request TOU/DPN agreement without attribute: uuid')
        end
      end

      context 'when remote_tou_dpn_agreement does not exist' do
        let(:euresource_response_status) { 404 }
        let(:euresource_response_body)   { 'None found' }
        let(:error_message)              do
          "Received unexpected response for tou_dpn_agreement. Response status: 404. Response body: #{euresource_response_body}"
        end

        it 'raises an error' do
          expect {
            PatientEnrollment.new(uuid: patient_enrollment_uuid).tou_dpn_agreement
          }.to raise_error(PatientEnrollment::RemotePatientEnrollmentError, error_message)
        end
      end
    end

    describe 'language_code' do
      it 'returns the language_code of the tou dpn agreement' do
        expect(PatientEnrollment.new(uuid: patient_enrollment_uuid).language_code).to eq('jpn')
      end
    end

    describe 'script direction' do
      it 'defaults to ltr' do
        expect(PatientEnrollment.new(uuid: patient_enrollment_uuid).script_direction).to eq('ltr')
      end

      context 'when script is read right to left' do
        let(:euresource_response_body)   { {html: tou_dpn_agreement_html, language_code: 'heb'}.to_json }

        it 'is rtl' do
          expect(PatientEnrollment.new(uuid: patient_enrollment_uuid).script_direction).to eq('rtl')
        end
      end
    end
  end

  describe 'remote_tou_dpn_agreement' do
    context 'when no uuid provided' do
      it 'raises an error' do
        expect {
          PatientEnrollment.new.send(:remote_tou_dpn_agreement)
        }.to raise_error(PatientEnrollment::PatientEnrollmentError, 'Cannot request TOU/DPN agreement without attribute: uuid')
      end
    end

    context 'when remote call returns an error' do
      include_context 'Euresource::PatientEnrollment#tou_dpn_agreement response'
      let(:euresource_response_status) { 404 }
      let(:euresource_response_body)   { 'remote service error' }

      it 'raises an error' do
        expect{
          PatientEnrollment.new(uuid: patient_enrollment_uuid).send(:remote_tou_dpn_agreement)
        }.to raise_error(
          PatientEnrollment::RemotePatientEnrollmentError,
          "Received unexpected response for tou_dpn_agreement. " <<
          "Response status: #{euresource_response_status}. Response body: #{euresource_response_body}")
      end
    end
  end
  
  describe 'grid_formatted' do
    let(:initials)        { 'TD' }
    let(:email)           { 'the-dude@gmail.com' }
    let(:activation_code) { 'ABCDEFG' }
    let(:subject_id)      { 'Subject-001' }
    let(:state)           { 'invited' }
    let(:created_at)      { '2015-02-26 18:47:07 UTC' }
    let(:patient_enrollment_attributes) do
      {
        initials: initials,
        email: email,
        activation_code: activation_code,
        subject_id: subject_id,
        state: state,
        created_at: created_at
      }
    end
    
    subject { patient_enrollment }

    context 'with all attributes' do
      let(:patient_enrollment) { (build :patient_enrollment, patient_enrollment_attributes).grid_formatted }
      
      its([:initials])        { is_expected.to eq(initials) }
      its([:email])           { is_expected.to eq('th******@gm***.com') }
      its([:activation_code]) { is_expected.to eq(activation_code) }
      its([:subject_id])      { is_expected.to eq(subject_id) }
      its([:state])           { is_expected.to eq('Invited') }
      its([:created_at])      { is_expected.to eq('26-FEB-2015') }
    end
      
    context 'with missing email' do
      let(:missing_email_attributes) { patient_enrollment_attributes.merge!(email: nil) }
      let(:patient_enrollment)     { build :patient_enrollment, missing_email_attributes }

      its(:email) { is_expected.to eq(nil) }
    end

    context 'with missing created at' do
      let(:missing_created_at_attributes) { patient_enrollment_attributes.merge!(created_at: nil) }
      let(:patient_enrollment)          { build :patient_enrollment, missing_created_at_attributes }

      its(:created_at) { is_expected.to eq(nil) }
    end

    context 'with missing state' do
      let(:missing_state_attributes) { patient_enrollment_attributes.merge!(state: nil) }
      let(:patient_enrollment)     { build :patient_enrollment, missing_state_attributes }

      its(:state) { is_expected.to eq(nil) }
    end

    describe 'anonymize email' do
      let(:patient_enrollment) { build :patient_enrollment, patient_enrollment_attributes }
      
      context 'when not an email' do
        let(:email) { 'some-weird-string' }
        its(:anonymized_email) { is_expected.to eq('so***************@***.') }
      end

      context 'when an empty string' do
        let(:email) { '' }
        its(:anonymized_email) { is_expected.to eq('') }
      end

      context 'when a short user' do
        let(:email) { 'a@g.com' }
        its(:anonymized_email) { is_expected.to eq('a***@g***.com') }
      end
    end
  end
end




