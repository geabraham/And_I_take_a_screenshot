shared_context 'Euresource::PatientEnrollment#tou_dpn_agreement response' do
  before do
    response_double = double('response').tap do |res|
      allow(res).to receive(:status).and_return(euresource_response_status)
      allow(res).to receive(:body).and_return(euresource_response_body)
    end
    allow(Euresource::PatientEnrollment).to receive(:invoke).with(:tou_dpn_agreement, {uuid: patient_enrollment_uuid}).and_return(response_double)
  end
end