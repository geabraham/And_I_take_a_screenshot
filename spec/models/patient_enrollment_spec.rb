require 'spec_helper'

describe PatientEnrollment do
  let(:patient_enrollment_uuid) { '34e147aa-c45d-4dc2-a434-786cca464cc7' }

  describe 'accessors' do
    it_behaves_like 'includes ActiveModel::Model', [:uuid, :login, :password, :security_question, :answer, :activation_code,
      :login_confirmation, :initials, :email, :enrollment_type, :activation_code, :language_code, :study_uuid, :study_site_uuid,
      :subject_id, :state, :tou_accepted_at]
  end

  describe '#by_study_and_study_site' do
    before { allow(Rails.logger).to receive(:info) }

    context 'when study_uuid is blank' do
      it 'logs the error' do
        expect(Rails.logger).to receive(:error).with('Required argument study_uuid is blank.')
        PatientEnrollment.by_site_and_study_site('', 'study_site_uuid') rescue nil
      end

      it 'raises an error' do
        expect { PatientEnrollment.by_site_and_study_site('', 'study_site_uuid') }
          .to raise_error(ArgumentError, 'Required argument study_uuid is blank.')
      end
    end

    context 'when study_site_uuid is blank' do
      it 'logs the error' do
        expect(Rails.logger).to receive(:error).with('Required argument study_site_uuid is blank.')
        PatientEnrollment.by_site_and_study_site('study_uuid', '') rescue nil
      end

      it 'raises an error' do
        expect { PatientEnrollment.by_site_and_study_site('study_uuid', '') }
          .to raise_error(ArgumentError, 'Required argument study_site_uuid is blank.')
      end
    end

    context 'when required parameters are provided' do
      context 'when Euresource encounters an error' do
        it 'logs the error'
        it 'raises the error'
      end

      context 'when Euresource successfully returns 0 enrollments' do
        it 'returns an empty array'
      end

      context 'when Euresource returns 1 or more patient enrollments' do
        it 'returns an array of PatientEnrollment objects derived from the Euresource response body'
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
end




