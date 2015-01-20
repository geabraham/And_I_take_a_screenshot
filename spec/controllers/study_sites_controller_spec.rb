require 'spec_helper'

describe StudySitesController do
  describe 'GET index' do
    context 'when user is not logged in' do
      it 'redirects to iMedidata' do
        get :index
        expect(response).to redirect_to("#{CAS_BASE_URL}/login?service=#{CGI.escape(request.original_url)}")
      end
    end
  end
end