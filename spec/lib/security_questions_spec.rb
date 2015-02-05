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
    let(:ara_security_questions) do
      get_questions("ara")
    end
    let(:cze_security_questions) do
      get_questions("cze")
    end
    let(:chi_security_questions) do
      get_questions("chi")
    end
    let(:dan_security_questions) do
      get_questions("dan")
    end
    let(:dut_security_questions) do
      get_questions("dut")
    end
    let(:eng_security_questions) do
      get_questions("eng")
    end
    let(:fra_security_questions) do
      get_questions("fra")
    end
    let(:frc_security_questions) do
      get_questions("frc")
    end
    let(:ger_security_questions) do
      get_questions("ger")
    end
    let(:heb_security_questions) do
      get_questions("heb")
    end
    let(:hun_security_questions) do
      get_questions("hun")
    end
    let(:ita_security_questions) do
      get_questions("ita")
    end
    let(:jpn_security_questions) do
      get_questions("jpn")
    end
    let(:kor_security_questions) do
      get_questions("kor")
    end
    let(:pol_security_questions) do
      get_questions("pol")
    end
    let(:rus_security_questions) do
      get_questions("rus")
    end
    let(:spa_security_questions) do
      get_questions("spa")
    end
    let(:twn_security_questions) do
      get_questions("twn")
    end
    let(:vie_security_questions) do
      get_questions("vie")
    end


    context 'when requesting security questions for existing locale' do
      it 'returns security questions' do
        expect(SecurityQuestions.find('ara')).to eq(ara_security_questions)
        expect(SecurityQuestions.find('cze')).to eq(cze_security_questions)
        expect(SecurityQuestions.find('chi')).to eq(chi_security_questions)
        expect(SecurityQuestions.find('dan')).to eq(dan_security_questions)
        expect(SecurityQuestions.find('dut')).to eq(dut_security_questions)
        expect(SecurityQuestions.find('eng')).to eq(eng_security_questions)
        expect(SecurityQuestions.find('fra')).to eq(fra_security_questions)
        expect(SecurityQuestions.find('frc')).to eq(frc_security_questions)
        expect(SecurityQuestions.find('ger')).to eq(ger_security_questions)
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
        begin
          expect(Rails.logger).to receive(:info).with("Security questions for requested locale not found: xxx")
          SecurityQuestions.find("xxx")
        rescue
        end
      end
    end


  end
end
