require 'spec_helper'

describe PatientManagementController do
  describe 'GET available_subjects' do
    let(:verb)      { :get }
    let(:action)    { :available_subjects }
    let(:user_uuid) { '1f0e0d68-d679-4661-8689-b08311142ba0' }
    before do
      allow(CASClient::Frameworks::Rails::Filter).to receive(:filter).and_return(true)
      session[:cas_extra_attributes] = {
        user_email: 'testuser@gmail.com',
        user_uuid: user_uuid
      }.stringify_keys
    end

    context 'without study and study site parameters' do
      let(:params)               { {} }
      let(:expected_template)    { 'error' }
      let(:expected_status_code) { 422 }

      it_behaves_like 'renders expected template'
      it_behaves_like 'returns expected status'
    end

    context 'with study and study site parameters' do
      let(:study_uuid)      { '7b0bc206-9609-45e5-8d8b-8fe067cba4ea' }
      let(:study_site_uuid) { '39311a11-8310-47f3-9cea-e763c2381fec' }
      let(:params)               { {study_uuid: study_uuid, study_site_uuid: study_site_uuid} }

      context 'when request fails' do
        let(:expected_body)        { [].to_json }
        let(:expected_status_code) { 200 }
        before do
          allow(Euresource::Subject).to receive(:get).with(:all, {params: {
            study_uuid: study_uuid,
            study_site_uuid: study_site_uuid,
            available: true}}).and_raise(Euresource::ResourceNotFound.new('Failed.'))
        end

        it_behaves_like 'returns expected body'
        it_behaves_like 'returns expected status'
      end

      context 'when request is successful' do
        let(:expected_body)        { [['Subject001', 'Subject001'], ['Subject002', 'Subject002']].to_json }
        let(:expected_status_code) { 200 }
        let(:subject1_attrs)       { {uuid: SecureRandom.uuid, subject_identifier: 'Subject001'}.stringify_keys }
        let(:subject2_attrs)       { {uuid: SecureRandom.uuid, subject_identifier: 'Subject002'}.stringify_keys }
        let(:subject1)             { double('subject').tap {|s| allow(s).to receive(:attributes).and_return(subject1_attrs)} }
        let(:subject2)             { double('subject').tap {|s| allow(s).to receive(:attributes).and_return(subject2_attrs)} }
        let(:subjects)             { [subject1, subject2] }
        before do
          allow(Euresource::Subject).to receive(:get).with(:all, {params: {
            study_uuid: study_uuid,
            study_site_uuid: study_site_uuid,
            available: true}}).and_return(subjects)
        end

        it_behaves_like 'returns expected body'
        it_behaves_like 'returns expected status'
      end
    end
  end
end
