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
  
  describe "POST 'activate'" do
    let(:params)               { {id: SecureRandom.uuid} }
    let(:verb)                 { :post }
    let(:action)               { :activate }
    let(:expected_status_code) { 200 }

    it_behaves_like 'returns expected status'
  end
end
