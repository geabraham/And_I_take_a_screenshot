require 'spec_helper'

describe PatientInvitationFormHelper do
  let(:test_class)      { Class.new { extend PatientInvitationFormHelper } }
  let(:study_uuid)      { '34e89d88-455b-4cd4-928c-29780b3dcdc3' }
  let(:study_site_uuid) { 'c4c0e7ec-1aaf-4319-9921-22a0a1c9f7af' }
  let(:country_code)    { 'USA' }
  let(:language_code)   { 'eng' }
  let(:subject)         { 'Subject-001' }
  let(:initials)        { 'E.G.' }
  let(:email)           { 'ellieg@gmail.com' }
  let(:valid_form_params) do
    {
      study_uuid: study_uuid,
      study_site_uuid: study_site_uuid,
      patient_enrollment: {
        country_language: {country_code: country_code, language_code: language_code}.to_json,
        subject: subject,
        initials: initials,
        email: email
      }
    }
  end
  let(:expected_patient_enrollment_params) do
    {
      study_uuid: study_uuid,
      study_site_uuid: study_site_uuid,
      country_code: country_code,
      language_code: language_code,
      subject_id: subject,
      initials: initials,
      email: email,
      enrollment_type: 'in-person'
    }
  end

  describe 'clean_params_for_patient_enrollment_params' do
    context 'when valid params' do
      it 'returns the expected params' do
        expect(test_class.clean_params_for_patient_enrollment(valid_form_params)).to eq(expected_patient_enrollment_params)
      end
    end

    context 'when invalid params' do
      it 'raises an argument error' do
        expect { test_class.clean_params_for_patient_enrollment }
          .to raise_error(ArgumentError, 'Missing one or more required params: study_uuid, study_site_uuid, patient_enrollment.')
      end
    end

    context 'with invalid patient enrollment params' do
      let(:not_all_params) { {study_uuid: study_uuid, study_site_uuid: study_site_uuid, patient_enrollment: {}} }
      it 'raises an argument error' do
        expect { test_class.clean_params_for_patient_enrollment(not_all_params) }
          .to raise_error(ArgumentError, 'Missing one or more required patient enrollment params: country_language, subject.')
      end
    end
  end  
end