require 'spec_helper'
require 'remote_security_questions'

describe RemoteSecurityQuestions do
  describe 'find or fetch' do
    let(:eng_security_questions) { {'user_security_questions' => [{'id' => 1, 'name' => 'What is the answer to life, the unverse, and everything?'}]} }
    before do
      Rails.cache.write('eng_security_questions', eng_security_questions['user_security_questions'])
      Rails.cache.write('chi_security_questions', nil)
    end
    after do
      Rails.cache.write('eng_security_questions', nil)
      Rails.cache.write('chi_security_questions', nil)
    end

    context 'when security questions exist' do
      it 'returns the value' do
        expect(RemoteSecurityQuestions.find_or_fetch('eng')).to eq(eng_security_questions['user_security_questions'])
      end
    end

    context 'when security questions do not exist' do
      it 'requests the security questions' do
        expect(RemoteSecurityQuestions).to receive(:remote_fetch).with('chi')
        RemoteSecurityQuestions.find_or_fetch('chi')
      end
    end
  end

  describe 'fetch' do
    let(:chi_security_questions) { {'user_security_questions' => [{'id' => 1, 'text' => '喜再见?'}]} }
    let(:response_double) do
      double('response').tap do |res|
        allow(res).to receive(:status).and_return(200)
        allow(res).to receive(:body).and_return(chi_security_questions.to_json)
      end
    end
    let(:request_double) do
      double('request').tap { |req| allow(req).to receive(:response).and_return(response_double) }
    end

    before { allow(IMedidataClient::SecurityQuestionsRequest).to receive(:new).and_return(request_double) }

    it 'makes an imedidata request with the corresponding locale' do
      expect(IMedidataClient::SecurityQuestionsRequest).to receive(:new).with(locale: 'chi').and_return(request_double)
      RemoteSecurityQuestions.remote_fetch('chi')
    end

    it 'assigns them to a constant' do
      RemoteSecurityQuestions.remote_fetch('chi')
      expect(Rails.cache.fetch('chi_security_questions')).to eq(chi_security_questions['user_security_questions'])
    end

    it 'returns the security questions' do
      expect(RemoteSecurityQuestions.remote_fetch('chi')).to eq(chi_security_questions['user_security_questions'])
    end
  end
end
