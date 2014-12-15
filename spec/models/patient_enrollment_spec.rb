require 'spec_helper'

describe PatientEnrollment do
  let(:patient_enrollment_uuid) { '34e147aa-c45d-4dc2-a434-786cca464cc7' }

  describe 'accessors' do
    it_behaves_like 'includes ActiveModel::Model', [:uuid, :login, :password, :security_question, :answer, :activation_code,
      :login_confirmation ]
  end

  describe 'tou_dpn_agreement' do
    include_context 'Euresource::PatientEnrollment#tou_dpn_agreement response'
    let(:tou_dpn_agreement_body)     { "<body><p>Maybe Christmas, the Grinch thought, doesn't come from a store.</p></body>" }
    let(:tou_dpn_agreement_html)     { "<html>#{tou_dpn_agreement_body}</html>"}
    let(:euresource_response_status) { 200 }
    let(:euresource_response_body)   { {html: tou_dpn_agreement_html}.to_json }

    context 'when remote_tou_dpn_agreement exists' do
      it 'returns the body' do
        expect(PatientEnrollment.new(uuid: patient_enrollment_uuid).tou_dpn_agreement).to eq(tou_dpn_agreement_body)
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




