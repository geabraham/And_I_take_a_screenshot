# coding: utf-8
require 'spec_helper'
require 'security_questions'
require 'yaml'

describe SecurityQuestions do
  describe 'find' do
    let(:ara_security_questions) do
      YAML.load_file("config/securityquestions/ara.yml")

    end
    let(:cze_security_questions) do
      YAML.load_file("config/securityquestions/cze.yml")
    end
    let(:dan_security_questions) do
      YAML.load_file("config/securityquestions/dan.yml")
    end
    let(:deu_security_questions) do
      YAML.load_file("config/securityquestions/deu.yml")
    end
    let(:dut_security_questions) do
      YAML.load_file("config/securityquestions/dut.yml")
    end
    let(:eng_security_questions) do
      YAML.load_file("config/securityquestions/eng.yml")
    end
    let(:heb_security_questions) do
      YAML.load_file("config/securityquestions/heb.yml")
    end
    let(:hun_security_questions) do
      YAML.load_file("config/securityquestions/hun.yml")
    end
    let(:ita_security_questions) do
      YAML.load_file("config/securityquestions/ita.yml")
    end
    let(:jpn_security_questions) do
      YAML.load_file("config/securityquestions/jpn.yml")
    end
    let(:kor_security_questions) do
      YAML.load_file("config/securityquestions/kor.yml")
    end
    let(:pol_security_questions) do
      YAML.load_file("config/securityquestions/pol.yml")
    end
    let(:rus_security_questions) do
      YAML.load_file("config/securityquestions/rus.yml")
    end
    let(:zha_security_questions) do
      YAML.load_file("config/securityquestions/zha.yml")
    end
    let(:zho_security_questions) do
      YAML.load_file("config/securityquestions/zho.yml")
    end

    context 'when requesting security questions for existing locale' do
      it 'returns security questions' do
        expect(SecurityQuestions.find('ara')).to eq(ara_security_questions)
        expect(SecurityQuestions.find('cze')).to eq(cze_security_questions)
        expect(SecurityQuestions.find('dan')).to eq(dan_security_questions)
        expect(SecurityQuestions.find('deu')).to eq(deu_security_questions)
        expect(SecurityQuestions.find('dut')).to eq(dut_security_questions)
        expect(SecurityQuestions.find('eng')).to eq(eng_security_questions)
        expect(SecurityQuestions.find('heb')).to eq(heb_security_questions)
        expect(SecurityQuestions.find('hun')).to eq(hun_security_questions)
        expect(SecurityQuestions.find('ita')).to eq(ita_security_questions)
        expect(SecurityQuestions.find('jpn')).to eq(jpn_security_questions)
        expect(SecurityQuestions.find('kor')).to eq(kor_security_questions)
        expect(SecurityQuestions.find('pol')).to eq(pol_security_questions)
        expect(SecurityQuestions.find('rus')).to eq(rus_security_questions)
        expect(SecurityQuestions.find('zha')).to eq(zha_security_questions)
        expect(SecurityQuestions.find('zho')).to eq(zho_security_questions)

      end
    end

    context "when requesting security questions for locale that doesn't exist" do
      it 'throws exception' do
        expect{SecurityQuestions.find("xxx") }.to raise_error("Locale not found: xxx")
      end
    end

  end
end
