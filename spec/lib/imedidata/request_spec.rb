require 'spec_helper'
require 'imedidata/client'

describe IMedidataClient::Request do
  let(:request) { IMedidataClient::Request.new }

  describe '.required_attributes' do
    it('defaults to the empty array') { expect(IMedidataClient::Request.required_attributes).to eq([]) }
  end

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
      it 'raises a no method error' do
        expect { request.request_body }.to raise_error(
          NoMethodError,
          "undefined method `request_body' for #{request}")
      end
    end
  end

  describe 'path' do
    context 'when undefined' do
      it 'raises an error' do
        expect { request.path }.to raise_error(
          IMedidataClient::IMedidataClientError,
          "No default request path. Please define a request path for the subclass.")
      end
    end
  end

  describe 'imedidata_connection' do
    it 'returns a faraday connection' do
      expect(request.imedidata_connection).to be_a(Faraday::Connection)
    end
  end

  describe 'response' do
    context 'when no http method defined' do
      it 'raises an error' do
        expect { request.response }.to raise_error(
          IMedidataClient::IMedidataClientError,
          "No default http method. Please define an http method for the subclass.")
      end
    end
  end
end
