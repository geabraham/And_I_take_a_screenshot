require 'spec_helper'

describe ApplicationController do
  describe 'localization' do
    controller { def index; end }
    after { I18n.locale = I18n.default_locale }
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

    context 'when a session value is set' do
      before { session[:language_code] = :kor }

      it 'overrides the parameter' do
        get :index, language_code: :rus
        expect(I18n.locale).to eq(:kor)
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
