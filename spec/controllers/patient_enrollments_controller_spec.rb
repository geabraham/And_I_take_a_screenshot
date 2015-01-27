require 'spec_helper'

describe PatientEnrollmentsController do
  let(:params) { nil }
  let(:jpn_security_questions) do
    [{'name'=>'生まれた年を入力してください。', 'id'=>'1'},
     {'name'=>'ソーシャルセキュリティ番号、納税者ID、健康保険証番号の下4桁は何ですか?', 'id'=>'2'}]
  end
  before do
    allow(RemoteSecurityQuestions).to receive(:find_or_fetch).with(I18n.default_locale).and_return([{}])
    allow(RemoteSecurityQuestions).to receive(:find_or_fetch).with('jpn').and_return(jpn_security_questions)
  end
  describe 'GET new' do
    let(:verb)              { :get }
    let(:action)            { :new }
    let(:expected_template) { 'patient_registration' }

    context 'when a patient enrollment uuid is present' do
      let(:tou_dpn_agreement_body)  { 'Consider yourself warned.' }
      let(:patient_enrollment)      { double('PatientEnrollment') }
      let(:patient_enrollment_uuid) { SecureRandom.uuid }

      before do
        session[:patient_enrollment_uuid] = patient_enrollment_uuid
        allow(PatientEnrollment).to receive(:new).with(uuid: patient_enrollment_uuid).and_return(patient_enrollment)
        allow(patient_enrollment).to receive(:tou_dpn_agreement_body).and_return(tou_dpn_agreement_body)
        allow(patient_enrollment).to receive(:language_code).and_return('jpn')
      end

      context 'when successful' do
        let(:expected_status_code) { 200 }

        it_behaves_like 'returns expected status'
        it_behaves_like 'renders expected template'
      end

      it 'assigns @tou_dpn_agreement_body' do
        get :new
        expect(assigns(:tou_dpn_agreement_body)).to eq(tou_dpn_agreement_body)
      end

      describe 'security questions' do
        it 'assigns @security_questions to a set of questions using the locale parameter' do
          get :new, locale: 'jpn'
          expect(assigns(:security_questions)).to eq(jpn_security_questions.map {|sq| sq.values})
        end
      end
    end

    context 'when no patient enrollment uuid is present in the request' do
      let(:expected_status_code) { 422 }
      let(:error_response_body)  do 
        {message: 'Unable to continue with registration. Error: Cannot request TOU/DPN agreement without attribute: uuid'}.to_json
      end

      it_behaves_like 'returns expected status'
      it_behaves_like 'returns expected error response body'
    end
  end
  
  describe 'POST patient_enrollments/register' do
    let(:verb)                 { :post }
    let(:action)               { :register }
    let(:expected_status_code) { 200 }
    let(:expected_template)    { 'patient_registration' }
    let(:login)                { 'cdr-adama@gmail.com' }
    let(:password)             { 'ejolmos' }
    let(:required_register_params) { {login: login, password: password} }

    before { Euresource::PatientEnrollments.stub(:invoke) }

    context 'when patient enrollment parameter is missing' do
      let(:expected_status_code) { 422 }
      let(:error_response_body)  do 
        {errors: 'param is missing or the value is empty: patient_enrollment'}.to_json
      end

      it_behaves_like 'returns expected status'
      it_behaves_like 'returns expected error response body'
    end

    context 'when required parameters are missing' do
      before { required_register_params.delete(:password) }
      let(:params) { {patient_enrollment: required_register_params} }
      let(:expected_status_code) { 422 }
      let(:error_response_body)  do 
        {errors: 'param is missing or the value is empty: password'}.to_json
      end

      it_behaves_like 'returns expected status'
      it_behaves_like 'returns expected error response body'
    end

    context 'when security_question or answer is present and the other is missing' do
      before { required_register_params.merge!(security_question: '2') }
      let(:params) { {patient_enrollment: required_register_params} }

      let(:expected_status_code) { 422 }
      let(:error_response_body)  do 
        {errors: 'param is missing or the value is empty: answer'}.to_json
      end

      it_behaves_like 'returns expected status'
      it_behaves_like 'returns expected error response body'
    end
    # context 'when parameters for existing user are missing' do
    #   let(:params)               { }
    #   let(:expected_status_code) { 422 }
    #   let(:error_response_body)  do 
    #     {message: 'Unable to complete registration. ' <<
    #       'Cannot register without attributes: activation code, login and password.'}.to_json
    #   end

    #   it_behaves_like 'returns expected status'
    #   it_behaves_like 'returns expected error response body'
    # end

    context 'when no activation code is present in the current session' do
      it 'responds 4xx'
    end

    context 'when all required parameters and activation code are present' do
      before do
        session[:activation_code] = activation_code
        required_register_params.merge(forecast: 'snowmageddon')
      end
      let(:activation_code) { 'HX6PKN' }
      let(:params) { {patient_enrollment: required_register_params} }
      
      describe 'permitted parameters' do
        it 'assigns register parameters' do
          post :register, params
          expect(assigns(:register_params)).to match({
            login: login,
            password: password, 
            activation_code: activation_code, 
            tou_accepted_at: /[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} [-|\+|][0-9]{4}/}.stringify_keys)
        end

        context 'when new user params are present' do
          let(:security_question) { '2' }
          let(:answer) { '42' }
          let(:params) { {patient_enrollment: required_register_params.merge(security_question: '2', answer: '42')} }

          it 'assigns register parameters' do
            post :register, params
            expect(assigns(:register_params)).to match({
              login: login,
              password: password, 
              activation_code: activation_code, 
              tou_accepted_at: /[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} [-|\+|][0-9]{4}/,
              security_question_id: '2',
              answer: '42'}.stringify_keys)
          end
        end
      end

      describe 'request to register' do
        it 'makes a request to Euresource::PatientEnrollments register' do
          register_params = {
            login: login,
            password: password, 
            activation_code: activation_code, 
            tou_accepted_at: /[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} [-|\+|][0-9]{4}/}.stringify_keys
          expect(Euresource::PatientEnrollments).to receive(:invoke).with(:register, register_params)
          post :register, params
        end
      end

      context 'when request to register is successful' do
        it_behaves_like 'returns expected status'
        it_behaves_like 'renders expected template'
      end
    end
  end
end
