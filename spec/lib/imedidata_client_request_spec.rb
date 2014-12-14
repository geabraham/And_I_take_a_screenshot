require 'spec_helper'
require 'imedidata_client_request'

describe IMedidataClient::Request do
  let(:request) { IMedidataClient::Request.new }

  describe 'http_method' do
    context 'when undefined' do
      it 'raises an error' do
        expect { request.http_method }.to raise_error(
          IMedidataClient::IMedidataClientError, 
          "No default http method. Please define an http method for the subclass.")
      end
    end
  end

  describe 'request_body' do
    context 'when undefined' do
      it 'raises an error' do
        expect { request.request_body }.to raise_error(
          IMedidataClient::IMedidataClientError, 
          "No default request body. Please define an request body for the subclass.")
      end
    end
  end
end
