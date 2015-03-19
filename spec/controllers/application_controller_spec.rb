require 'spec_helper'

describe ApplicationController do
  describe 'set_locale' do
    let(:bad_language_code) { :lol }

    before { allow(I18n).to receive(:locale_available?).and_call_original }

    controller do
      def index
        render json: 'ok', status: :ok
      end
    end

    after { I18n.locale = I18n.default_locale }

    context 'when no language_code parameter provided' do
      it 'uses the default locale' do
        get :index
        expect(I18n.locale).to eq(I18n.default_locale)
      end
    end

    context 'when an invalid language_code parameter is provided' do
      it 'checks the language_code is valid' do
        expect(I18n).to receive(:locale_available?).with(bad_language_code.to_s)
        get :index, language_code: bad_language_code
      end

      it 'uses the default locale' do
        get :index, language_code: bad_language_code
        expect(I18n.locale).to eq(I18n.default_locale)
      end

      it 'returns ok' do
        get :index, language_code: bad_language_code
        expect(response.status).to eq(200)
      end
    end

    context 'when a valid language_code' do
      it 'is localized' do
        get :index, language_code: :rus
        expect(I18n.locale).to eq(:rus)
      end
    end

    context 'when a session value is set' do
      before { session[:language_code] = :kor }

      context 'when valid' do
        it 'overrides the parameter' do
          get :index, language_code: :rus
          expect(I18n.locale).to eq(:kor)
        end
      end

      context 'when invalid' do
        before { session[:language_code] = bad_language_code }

        it 'checks the language_code is valid' do
          expect(I18n).to receive(:locale_available?).with(bad_language_code)
          get :index
        end

        it 'uses the default value' do
          get :index
          expect(I18n.locale).to eq(I18n.default_locale)
        end
      end
    end
  end

  describe 'set_in_app_browser' do
    controller { def index; end }

    context "when user agent contains 'PatientCloud'" do
      before do
        request.headers['HTTP_USER_AGENT'] = "Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Mobile/11A465 " <<
          "#{MOBILE_APP_USER_AGENT_STRING} for iPhone"
      end

      it 'assigns in_app_browser as true' do
        get :index
        expect(assigns(:in_app_browser)).to eq(true)
      end
    end

    context "when user agent does not contain 'PatientCloud'" do
      it 'assigns in_app_browser as false' do
        get :index
        expect(assigns(:in_app_browser)).to eq(false)
      end
    end
  end

  describe 'GET /logout' do
    before do
      user_uuid = SecureRandom.uuid
      session[:cas_extra_attributes] = {user_uuid: user_uuid}.stringify_keys!
    end

    it 'clears the session' do
      get :logout
      expect(session[:cas_extra_attributes]).to be_nil
    end

    it 'redirects to the logout url' do
      get :logout
      expect(response).to redirect_to("#{CAS_BASE_URL}/logout?service")
    end
  end

  describe '#routing_error' do
    it 'raises an ActionController::RoutingError' do
      expect { controller.send(:routing_error) }.to raise_error(ActionController::RoutingError)
    end
  end
end
