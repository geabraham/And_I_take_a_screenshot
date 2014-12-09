require 'rails_helper'

describe PatientEnrollment do
  describe 'accessors' do
    it_behaves_like 'includes ActiveModel::Model', [:uuid, :login, :password, :security_question, :answer, :activation_code,
      :login_confirmation ]
  end

  describe 'tou_dpn_agreement' do
    #before { Euresource::PatientEnrollment.stub(:invoke) }
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
          res.stub(:status).and_return(404)
          res.stub(:body).and_return('remote service error')
        end
        Euresource::PatientEnrollment.stub(:invoke).with(:tou_dpn_agreement, {uuid: patient_enrollment_uuid}).and_return(response_double)
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
