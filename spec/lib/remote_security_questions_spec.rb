require 'spec_helper'
require 'remote_security_questions'

describe RemoteSecurityQuestions do
  describe 'find or fetch' do
    let(:eng_security_questions) { [{'id' => 1, 'name' => 'What is the answer to life, the unverse, and everything?'}] }
    before do
      Rails.cache.write('eng_security_questions', eng_security_questions)
      Rails.cache.delete('jpn_security_questions')
    end
    after do
      Rails.cache.delete('eng_security_questions')
      Rails.cache.delete('jpn_security_questions')
    end

    context 'when security questions exist' do
      it 'returns the value' do
        expect(RemoteSecurityQuestions.find_or_fetch('eng')).to eq(eng_security_questions)
      end
    end

    context 'when security questions do not exist' do
      let(:jpn_security_questions) do
        {'user_security_questions' =>
          [{"name"=>"您在哪一年出生？", "id"=>"1"},
           {"name"=>"你的社会安全号码(SSN)或报税号码的最后四位数是什么?", "id"=>"2"},
           {"name"=>"您父亲的中间名是什么？", "id"=>"3"}]}
      end

      before do
        allow(RemoteSecurityQuestions).to receive(:request_security_questions!).with(locale: 'jpn').and_return(jpn_security_questions)
      end

      it 'requests the security questions' do
        expect(RemoteSecurityQuestions).to receive(:request_security_questions!).with(locale: 'jpn')
        RemoteSecurityQuestions.find_or_fetch('jpn')
      end

      it 'assigns the security questions key with the content' do
        RemoteSecurityQuestions.find_or_fetch('jpn')
        expect(Rails.cache.read('jpn_security_questions')).to eq(jpn_security_questions['user_security_questions'])
      end
    end
  end
end
