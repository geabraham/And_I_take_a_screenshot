require 'spec_helper'
require 'remote_security_questions'

describe RemoteSecurityQuestions do
  describe 'find or fetch' do
    let(:eng_security_questions) { [{id: 1, text: 'What is the answer to life, the unverse, and everything?'}] }
    before do
      ENG_SECURITY_QUESTIONS = eng_security_questions
      unless defined?(ZHO_SECURITY_QUESTIONS) == nil
        Kernel.send(:remove_const, 'ZHO_SECURITY_QUESTIONS')
      end
    end

    context 'when security questions exist' do
      it 'returns the value' do
        expect(RemoteSecurityQuestions.find_or_fetch('eng')).to eq(eng_security_questions)
      end
    end

    context 'when security questions do not exist' do
      it 'requests the security questions' do
        expect(RemoteSecurityQuestions).to receive(:fetch).with('zho')
        RemoteSecurityQuestions.find_or_fetch('zho')
      end
    end
  end

  describe 'fetch' do
    let(:zho_security_questions) { [{'id' => 1, 'text' => '喜再见?'}] }
    let(:response_double) do
      double('response').tap do |res|
        allow(res).to receive(:status).and_return(200)
        allow(res).to receive(:body).and_return(zho_security_questions.to_json)
      end
    end
    let(:request_double) do
      double('request').tap { |req| allow(req).to receive(:response).and_return(response_double) }
    end

    before { allow(IMedidataClient::SecurityQuestionsRequest).to receive(:new).and_return(request_double) }

    it 'makes an imedidata request with the corresponding locale' do
      expect(IMedidataClient::SecurityQuestionsRequest).to receive(:new).with(locale: 'zho').and_return(request_double)
      RemoteSecurityQuestions.fetch('zho')
    end

    it 'assigns them to a constant' do
      RemoteSecurityQuestions.fetch('zho')
      expect(ZHO_SECURITY_QUESTIONS).to eq(zho_security_questions)
    end
  end
end
