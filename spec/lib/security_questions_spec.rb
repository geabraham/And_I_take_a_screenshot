require 'spec_helper'
require 'security_questions'
require 'yaml'

def get_questions(locale)
  questions = YAML.load_file("config/locales/#{locale}.yml")[locale]["security_questions"]
  if questions
    questions.collect do |qs|
      qs.symbolize_keys
    end
  else
    raise StandardError "Unknown locale"
  end
end

describe SecurityQuestions do
  describe 'find' do
    let(:ara_security_questions) { get_questions("ara") }
    let(:chi_security_questions) { get_questions("chi") }
    let(:cze_security_questions) { get_questions("cze") }
    let(:dan_security_questions) { get_questions("dan") }
    let(:deu_security_questions) { get_questions("deu") }
    let(:dut_security_questions) { get_questions("dut") }
    let(:eng_security_questions) { get_questions("eng") }
    let(:fra_security_questions) { get_questions("fra") }
    let(:frc_security_questions) { get_questions("frc") }
    let(:heb_security_questions) { get_questions("heb") }
    let(:hun_security_questions) { get_questions("hun") }
    let(:ita_security_questions) { get_questions("ita") }
    let(:jpn_security_questions) { get_questions("jpn") }
    let(:kor_security_questions) { get_questions("kor") }
    let(:pol_security_questions) { get_questions("pol") }
    let(:rus_security_questions) { get_questions("rus") }
    let(:spa_security_questions) { get_questions("spa") }
    let(:twn_security_questions) { get_questions("twn") }
    let(:vie_security_questions) { get_questions("vie") }


    context 'when requesting security questions for existing locale' do
      it 'returns security questions' do
        expect(SecurityQuestions.find('ara')).to eq(ara_security_questions)
        expect(SecurityQuestions.find('chi')).to eq(chi_security_questions)
        expect(SecurityQuestions.find('cze')).to eq(cze_security_questions)
        expect(SecurityQuestions.find('dan')).to eq(dan_security_questions)
        expect(SecurityQuestions.find('deu')).to eq(deu_security_questions)
        expect(SecurityQuestions.find('dut')).to eq(dut_security_questions)
        expect(SecurityQuestions.find('eng')).to eq(eng_security_questions)
        expect(SecurityQuestions.find('fra')).to eq(fra_security_questions)
        expect(SecurityQuestions.find('frc')).to eq(frc_security_questions)
        expect(SecurityQuestions.find('heb')).to eq(heb_security_questions)
        expect(SecurityQuestions.find('hun')).to eq(hun_security_questions)
        expect(SecurityQuestions.find('ita')).to eq(ita_security_questions)
        expect(SecurityQuestions.find('jpn')).to eq(jpn_security_questions)
        expect(SecurityQuestions.find('kor')).to eq(kor_security_questions)
        expect(SecurityQuestions.find('pol')).to eq(pol_security_questions)
        expect(SecurityQuestions.find('rus')).to eq(rus_security_questions)
        expect(SecurityQuestions.find('spa')).to eq(spa_security_questions)
        expect(SecurityQuestions.find('twn')).to eq(twn_security_questions)
        expect(SecurityQuestions.find('vie')).to eq(vie_security_questions)
      end

      it 'logs retrieval of security questions' do
        expect(Rails.logger).to receive(:info).with("Got security questions for locale: ara")
        SecurityQuestions.find('ara')
      end
    end

    context "when requesting security questions for locale that doesn't exist" do
      it 'throws exception' do
        expect{SecurityQuestions.find("xxx") }.to raise_error(I18n::InvalidLocale, "\"xxx\" is not a valid locale")
      end

      it 'logs exception' do
        expect(Rails.logger).to receive(:info).with("Security questions for requested locale not found: xxx")
        SecurityQuestions.find("xxx") rescue nil
      end
    end


  end
end
