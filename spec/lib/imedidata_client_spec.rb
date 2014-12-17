require 'spec_helper'
require 'imedidata_client'

describe IMedidataClient do
  let(:test_class) { Class.new { extend IMedidataClient } }
  let(:response)   do
    {user_security_questions: [{id: 1, text: 'Whats the secret to life the universe and everything?'}]}.to_json
  end
  
  describe 'request_security_questions!' do
    context 'without required arguments' do
      it 'raises an error' do
        expect { 
          test_class.request_security_questions!({}) 
        }.to raise_error(IMedidataClient::Request::RequestArgumentError, 'Invalid arguments. Please provide locale.')
      end
    end

    context 'with valid arguments' do
      let(:request_path) { IMED_BASE_URL + IMedidataClient::SecurityQuestionsRequest.new(locale: 'zho').path }

      before do
        WebMock.stub_request(:get, IMED_BASE_URL + IMedidataClient::SecurityQuestionsRequest.new(locale: 'zho').path)
          .to_return(status: 200, body: response)
      end

      it 'makes a request to authenticate the user with IMedidata' do
        test_class.request_security_questions!({locale: 'zho'})
        expect(WebMock).to have_requested(:get, request_path)
      end

      context 'when response is successful' do
        it 'returns the response body' do
          expect(test_class.request_security_questions!({locale: 'zho'})).to eq(JSON.parse(response)['user_security_questions'])
        end
      end

      context 'when response is not successful' do
        before do
          WebMock.stub_request(:get, request_path).to_return(status: 303, body: "Unexpected response")
        end

        it 'raises an error' do
          expect { 
            test_class.request_security_questions!({locale: 'zho'}) 
          }.to raise_error(
            IMedidataClient::IMedidataClientError,
            "Security Questions request failed for zho. Response: 303 Unexpected response"
          )
        end
      end
    end
  end
end
