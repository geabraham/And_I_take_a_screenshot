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

    describe 'localization' do
      context 'when no language_code parameter provided' do
        it 'uses the default locale' do
          get :index
          expect(I18n.locale).to eq(I18n.default_locale)
        end
      end

      context 'when an invalid language_code parameter is provided' do
        it 'uses the default locale' do
          get :index, language_code: :boo
          expect(I18n.locale).to eq(I18n.default_locale)
        end
      end

      context 'when a valid language_code' do
        it 'is localized' do
          get :index, language_code: :rus
          expect(I18n.locale).to eq(:rus)
        end
      end
    end
  end

  describe "GET patient_enrollment" do
    context 'with a valid and active activation code' do
      let(:activation_code_attributes) do
        {"activation_code" => 'WLCMHK',
         "state" => 'active',
         "language_code" => 'eng',
         "patient_enrollment_uuid" => 'xyz'}
      end
      let(:response_stub) do
        double('response').tap { |r| allow(r).to receive(:attributes).and_return(activation_code_attributes) }
      end

      before do
        allow(Euresource::ActivationCodes).to receive(:get).with({activation_code: params[:id]}).and_return(response_stub)
      end

      let(:params)               { {id: 'WLCMHK'} }
      let(:verb)                 { :get }
      let(:action)               { :validate }
      let(:expected_status_code) { 302 }

      it_behaves_like 'returns expected status'

      it 'adds activation_code and patient_enrollment_uuid to session' do
        get(:validate, {id: 'WLCMHK'})
        expect(session['activation_code']).to eq('WLCMHK')
        expect(session['patient_enrollment_uuid']).to eq('xyz')
        expect(session['language_code']).to eq('eng')
      end

      it "redirects to patient enrollment page" do
        get(:validate, {id: 'WLCMHK'})
        expect(subject).to redirect_to :action => :new,
                                       :controller => :patient_enrollments

      end

      context 'with a valid but deactivated activation code' do
        let(:activation_code_attributes) do
          {"activation_code" => 'WLCMHK',
           "state" => 'deactivated',
           "patient_enrollment_uuid" => 'xyz'}
        end
        let(:response_stub) do
          double('response').tap { |r| allow(r).to receive(:attributes).and_return(activation_code_attributes) }
        end

        before do
          allow(Euresource::ActivationCodes).to receive(:get).with({activation_code: params[:id]}).and_return(response_stub)
        end

        let(:params)               { {id: 'WLCMHK'} }
        let(:verb)                 { :get }
        let(:action)               { :validate }
        let(:error_response_body)  { "Activation Code must be in active state"}
        let(:expected_status_code) { 422 }

        it_behaves_like 'returns expected status'
        it_behaves_like 'returns expected error response body'

        it 'does not add activation_code and patient_enrollment_uuid to session' do
          get(:validate, {id: 'WLCMHK'})
          expect(session['activation_code']).to eq(nil)
          expect(session['patient_enrollment_uuid']).to eq(nil)
        end
      end

      context 'with an unknown activation code' do
        before do
          allow(Euresource::ActivationCodes).to receive(:get).with(anything()) {
            raise Euresource::ResourceNotFound.new(404,"Failed.  Response status: 404.")
            Euresource::ActivationCodes.new(attributes: {"activation_code" => '',
                                                         "state" => 'active',
                                                         "patient_enrollment_uuid" => 'xyz'})}
        end

        let(:params)               { {id: 'WLCMHK'} }
        let(:verb)                 { :get }
        let(:action)               { :validate }
        let(:error_response_body)  { "Failed.  Response status: 404."}
        let(:expected_status_code) { 404 }

        it_behaves_like 'returns expected status'
        it_behaves_like 'returns expected error response body'

        it 'does not add activation_code and patient_enrollment_uuid to session' do
          get(:validate, {id: 'WLCMHK'})
          expect(session['activation_code']).to eq(nil)
          expect(session['patient_enrollment_uuid']).to eq(nil)
        end
      end
    end
  end
end
