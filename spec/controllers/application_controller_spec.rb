require 'spec_helper'

describe ApplicationController do
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
end
