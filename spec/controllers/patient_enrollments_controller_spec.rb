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
  
  describe 'POST register' do
    let(:verb)                              { :post }
    let(:action)                            { :register }
    let(:expected_status_code)              { 200 }
    let(:expected_template)                 { 'patient_registration' }
    let(:login)                             { 'cdr-adama@gmail.com' }
    let(:password)                          { 'ejolmos' }
    let(:required_expected_register_params) { {login: login, password: password} }
    let(:activation_code)                   { 'HX6PKN' }
    let(:patient_enrollment_uuid)           { SecureRandom.uuid }

    before do
      allow(Euresource::PatientEnrollments).to receive(:invoke)
      @datetime_regex = /[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} [-|\+|][0-9]{4}/
      session[:activation_code] = activation_code
      session[:patient_enrollment_uuid] = patient_enrollment_uuid
    end

    context 'when patient enrollment parameter is missing' do
      let(:expected_status_code) { 422 }
      let(:error_response_body)  do 
        {errors: 'param is missing or the value is empty: patient_enrollment'}.to_json
      end

      it_behaves_like 'returns expected status'
      it_behaves_like 'returns expected error response body'
    end

    context 'when required parameters are missing' do
      let(:params)               { {patient_enrollment: required_expected_register_params} }
      let(:expected_status_code) { 422 }
      let(:error_response_body)  do 
        {errors: 'param is missing or the value is empty: password'}.to_json
      end

      before { required_expected_register_params.delete(:password) }

      it_behaves_like 'returns expected status'
      it_behaves_like 'returns expected error response body'
    end

    context 'when security_question or answer is present and the other is missing' do
      let(:params)               { {patient_enrollment: required_expected_register_params} }
      let(:expected_status_code) { 422 }
      let(:error_response_body)  do 
        {errors: 'param is missing or the value is empty: answer'}.to_json
      end

      before { required_expected_register_params.merge!(security_question: '2') }

      it_behaves_like 'returns expected status'
      it_behaves_like 'returns expected error response body'
    end

    context 'when no activation code is present in the current session' do
      before { session[:activation_code] = nil }

      it 'redirects to the activation code screen' do
        post :register, params
        expect(response).to redirect_to(activation_codes_path)
      end
    end

    context 'when no patient enrollment uuid is present in the current session' do
      before { session[:patient_enrollment_uuid] = nil }

      it 'redirects to the activation code screen' do
        post :register, params
        expect(response).to redirect_to(activation_codes_path)
      end
    end

    context 'when all required parameters, patient_enrollment_uuid and activation code are present' do
      let(:params) { {patient_enrollment: required_expected_register_params} }

      before { required_expected_register_params.merge(forecast: 'snowmageddon') }

      describe 'request to register' do
        let(:expected_register_params) do
          {
            login: login,
            password: password, 
            activation_code: activation_code, 
            tou_accepted_at: @datetime_regex
          }.stringify_keys
        end

        context 'with existing user params' do
          it 'makes a request to Euresource::PatientEnrollments register with existing user params' do
            expect(Euresource::PatientEnrollments).to receive(:invoke)
              .with(:register, {uuid: patient_enrollment_uuid}, {patient_enrollment: expected_register_params})
            post :register, params
          end
        end

        context 'with new user params' do
          let(:new_user_params) { {security_question: '2', answer: '42'} }
          let(:params)          { {patient_enrollment: required_expected_register_params.merge(new_user_params)} }
          let(:expected_register_params) do
            {
              login: login,
              password: password, 
              activation_code: activation_code, 
              tou_accepted_at: @datetime_regex,
              answer: '42',
              security_question_id: '2'
            }.stringify_keys
          end

          it 'makes a request to Euresource::PatientEnrollments register with new user params' do
            expect(Euresource::PatientEnrollments).to receive(:invoke)
              .with(:register, {uuid: patient_enrollment_uuid}, {patient_enrollment: expected_register_params})
            post :register, params
          end
        end

        context 'when request to register is successful' do
          let(:response_stub) do
            double('response').tap do |r|
              allow(r).to receive(:body).and_return('')
              allow(r).to receive(:status).and_return(200)
            end
          end

          before do
            allow(Euresource::PatientEnrollments).to receive(:invoke)
              .with(:register, {uuid: patient_enrollment_uuid}, {patient_enrollment: expected_register_params})
              .and_return(response_stub)
          end

          it_behaves_like 'returns expected status'
          it_behaves_like 'renders expected template'

          it 'clears the session' do
            post :register, params
            expect(session[:activation_code]).to be_nil
            expect(session[:patient_enrollment_uuid]).to be_nil
          end
        end

        context 'when request to register fails' do
          let(:response_body)        { 'Malformed create user request.' }
          let(:expected_status_code) { 400 }
          let(:error_response_body) do
            {errors: "Unable to complete registration: #{response_body}"}.to_json
          end
          let(:response_stub) do
            double('response').tap do |r|
              allow(r).to receive(:body).and_return(response_body)
              allow(r).to receive(:status).and_return(expected_status_code)
            end
          end

          before do
            allow(Euresource::PatientEnrollments).to receive(:invoke)
              .with(:register, {uuid: patient_enrollment_uuid}, {patient_enrollment: expected_register_params})
              .and_return(response_stub)
          end

          it_behaves_like 'returns expected status'
          it_behaves_like 'returns expected error response body'
        end
      end
    end
  end
end
