require 'spec_helper'

describe ActivationCodesController do
  describe "GET 'index'" do
    let(:params)               { nil }
    let(:verb)                 { :get }
    let(:action)               { :index }
    let(:expected_template)    { 'patient_registration' }
    let(:expected_status_code) { 200 }

    it_behaves_like 'returns expected status'
    it_behaves_like 'renders expected template'
  end

  describe "GET activate" do

    context 'valid and active activation code' do
      before do
        Euresource::ActivationCodes.stub(:get).with(anything()) {
          Euresource::ActivationCodes.new(attributes: {"activation_code" => '123',
                                                       "state" => 'active',
                                                       "patient_enrollment_uuid" => 'xyz'})}
      end

      let(:params)               { {id: '123'} }
      let(:verb)                 { :get }
      let(:action)               { :activate }
      let(:expected_status_code) { 200 }

      it_behaves_like 'returns expected status'

      it 'adds activation_code and patient_enrollment_uuid to session' do
        get(:activate, {id: '123'})
        expect(session['activation_code']).to eq('123')
        expect(session['patient_enrollment_uuid']).to eq('xyz')
      end

      context 'valid but deactivated activation code' do
        before do
          Euresource::ActivationCodes.stub(:get).with(anything()) {
            Euresource::ActivationCodes.new(attributes: {"activation_code" => '123',
                                                         "state" => 'deactivated',
                                                         "patient_enrollment_uuid" => 'xyz'})}
        end

        let(:params)               { {id: '123'} }
        let(:verb)                 { :get }
        let(:action)               { :activate }
        let(:error_response_body)  { "Activation Code must be in active state"}
        let(:expected_status_code) { 403 }

        it_behaves_like 'returns expected status'
        it_behaves_like 'returns expected error response body'

        it 'does not add activation_code and patient_enrollment_uuid to session' do
          get(:activate, {id: '123'})
          expect(session['activation_code']).to eq(nil)
          expect(session['patient_enrollment_uuid']).to eq(nil)
        end
      end

      context 'invalid activation code' do
        before do
          Euresource::ActivationCodes.stub(:get).with(anything()) {
            raise Euresource::ResourceNotFound.new(404,"Failed.  Response status: 404.")
            Euresource::ActivationCodes.new(attributes: {"activation_code" => '',
                                                         "state" => 'active',
                                                         "patient_enrollment_uuid" => 'xyz'})}
        end

        let(:params)               { {id: '123'} }
        let(:verb)                 { :get }
        let(:action)               { :activate }
        let(:error_response_body)  { "Failed.  Response status: 404."}
        let(:expected_status_code) { 404 }

        it_behaves_like 'returns expected status'
        it_behaves_like 'returns expected error response body'

        it 'does not add activation_code and patient_enrollment_uuid to session' do
          get(:activate, {id: '123'})
          expect(session['activation_code']).to eq(nil)
          expect(session['patient_enrollment_uuid']).to eq(nil)
        end
      end

      end

  end

end
