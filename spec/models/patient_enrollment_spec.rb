require 'spec_helper'

describe PatientEnrollment do
  describe 'accessors' do
    it_behaves_like 'includes ActiveModel::Model', [:uuid, :login, :password, :security_question, :answer, :activation_code,
      :login_confirmation ]
  end

  describe 'tou_dpn_agreement' do
    let(:patient_enrollment_uuid) { '34e147aa-c45d-4dc2-a434-786cca464cc7' }

    context 'when remote_tou_dpn_agreement exists' do
      let(:tou_dpn_agreement_body)  { "<body><p>Maybe Christmas, the Grinch thought, doesn't come from a store.</p></body>" }
      let(:tou_dpn_agreement_html)  { "<html>#{tou_dpn_agreement_body}</html>"}
      let(:status)                  { 200 }
      let(:body)                    { {html: tou_dpn_agreement_html}.to_json }

      before do
        response_double = double('response').tap do |res|
          allow(res).to receive(:status).and_return(status)
          allow(res).to receive(:body).and_return(body)
        end
        allow(Euresource::PatientEnrollment).to receive(:invoke).with(:tou_dpn_agreement, {uuid: patient_enrollment_uuid}).and_return(response_double)
      end

      it 'returns the body' do
        expect(PatientEnrollment.new(uuid: patient_enrollment_uuid).tou_dpn_agreement).to eq(tou_dpn_agreement_body)
      end
    end

    context 'when remote_tou_dpn_agreement does not exist' do
      let(:error_body)    { 'None found' }
      let(:error_message) { "Received unexpected response for tou_dpn_agreement. Response status: 404. Response body: #{error_body}" }
      before do
        response_double = double('response').tap do |res|
          allow(res).to receive(:status).and_return(404)
          allow(res).to receive(:body).and_return(error_body)
        end
        allow(Euresource::PatientEnrollment).to receive(:invoke).with(:tou_dpn_agreement, {uuid: patient_enrollment_uuid}).and_return(response_double)
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
        expect{
          PatientEnrollment.new.remote_tou_dpn_agreement
        }.to raise_error(PatientEnrollment::PatientEnrollmentError, 'Cannot request TOU/DPN agreement without attribute: uuid')
      end
    end

    context 'when remote call returns an error' do
      let(:patient_enrollment_uuid) { SecureRandom.uuid }
      let(:status)                  { 404 }
      let(:body)                    { 'remote service error' }

      before do
        response_double = double('response').tap do |res|
          allow(res).to receive(:status).and_return(status)
          allow(res).to receive(:body).and_return(body)
        end
        allow(Euresource::PatientEnrollment).to receive(:invoke).with(:tou_dpn_agreement, {uuid: patient_enrollment_uuid}).and_return(response_double)
      end

      it 'raises an error' do
        expect{
          PatientEnrollment.new(uuid: patient_enrollment_uuid).remote_tou_dpn_agreement
        }.to raise_error(
          PatientEnrollment::RemotePatientEnrollmentError,
          "Received unexpected response for tou_dpn_agreement. " <<
          "Response status: #{status}. Response body: #{body}")
      end
    end
  end
end
