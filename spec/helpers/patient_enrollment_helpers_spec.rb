require 'spec_helper'
describe PatientEnrollmentHelpers do
  let(:test_class) { Class.new { extend PatientEnrollmentHelpers } }
  let(:subject)    { 'Subject-001' }
  let(:study_uuid) { '96e6479f-a3bf-42a4-84de-0e49d31ec4db' }
  let(:study_site_uuid) { '22fc8408-9c85-41b9-8338-8e46cf96ecc2' }

  describe '#params_for_subject' do
    context 'with missing arguments' do
      it 'raises an error when all are missing' do
        expect { test_class.params_for_subject }.to raise_error(ArgumentError, 'Required params subject, study_uuid, study_site_uuid are missing.')
      end

      it 'raises an error when one is missing' do
        expect { test_class.params_for_subject(subject: subject, study_uuid: study_uuid) }.to raise_error(ArgumentError, 'Required param study_site_uuid is missing.')
      end
    end

    context 'with all required argumets' do
      let(:all_subject_params)      { {subject: subject, study_uuid: study_uuid, study_site_uuid: study_site_uuid} }
      let(:expected_subject_params) { {subject_id: subject, study_uuid: study_uuid, study_site_uuid: study_site_uuid} }

      it 'returns params with subject_id in place of subject' do
        expect(test_class.params_for_subject(all_subject_params)).to eq(expected_subject_params)
      end
    end
  end
end