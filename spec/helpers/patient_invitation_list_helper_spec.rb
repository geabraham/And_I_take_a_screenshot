require 'spec_helper'

describe PatientInvitationListHelper do
  let(:test_class)      { Class.new { extend PatientInvitationListHelper } }
  let(:uuid)            { "25c06a8b-47ed-4382-a44f-9b45ea87216a" }
  let(:initials)        { 'TD' }
  let(:email)           { 'the-dude@gmail.com' }
  let(:enrollment_type) { 'in-person' }
  let(:activation_code) { 'ABCDEFG' }
  let(:language_code)   { 'eng' }
  let(:study_uuid)      { 'fc3d182b-5a9d-43bb-a8ee-bb2c132805e9' }
  let(:study_site_uuid) { '1e05f961-040b-40a3-a714-fec78efd9b14' }
  let(:subject_id)      { 'Subject-001' }
  let(:state)           { 'invited' }
  let(:tou_accepted_at) { nil }
  let(:created_at)      { '2015-02-26 18:47:07 UTC' }
  let(:patient_enrollment_attributes) do
    {
      uuid: uuid,
      initials: initials,
      email: email,
      enrollment_type: enrollment_type,
      activation_code: activation_code,
      language_code: language_code,
      study_uuid: study_uuid,
      study_site_uuid: study_site_uuid,
      subject_id: subject_id,
      state: state,
      tou_accepted_at: nil,
      created_at: created_at
    }
  end
  let(:patient_enrollment_1) { build :patient_enrollment, patient_enrollment_attributes }

  describe '#fetch_patient_enrollments' do
    before { allow(test_class).to receive(:params).and_return({}) }

    context 'when no patient enrollments' do
      before { allow(PatientEnrollment).to receive(:by_study_and_study_site).and_return([]) }
      it 'returns the empty array' do
        expect(test_class.fetch_patient_enrollments).to eq([])
      end
    end

    context 'when multiple patient enrollments' do
      let(:uuid2)                  { 'a65bfb53-94a4-489b-a60f-c2f589ff159c' }
      let(:uuid3)                  { 'bf28e2c4-0e75-476d-839b-c966d6d2476f' }
      let(:created_at_2)           { '2015-02-25 18:47:07 UTC' }
      let(:created_at_3)           { '2015-02-24 18:47:07 UTC' }
      let(:patient_enrollment_2)   do
        build :patient_enrollment, patient_enrollment_attributes.merge(uuid: uuid2, created_at: created_at_2)
      end
      let(:patient_enrollment_3)   do
        build :patient_enrollment, patient_enrollment_attributes.merge(uuid: uuid3, created_at: created_at_3)
      end

      before do
        allow(PatientEnrollment).to receive(:by_study_and_study_site)
          .and_return([patient_enrollment_2, patient_enrollment_3, patient_enrollment_1])
        @patient_enrollments = test_class.fetch_patient_enrollments
      end

      it 'returns patient enrollments in reverse created at order' do
        expect(@patient_enrollments[0].uuid).to eq(patient_enrollment_1.uuid)
        expect(@patient_enrollments[1].uuid).to eq(patient_enrollment_2.uuid)
        expect(@patient_enrollments[2].uuid).to eq(patient_enrollment_3.uuid)
      end

      it 'returns anonymized emails' do
        expect(@patient_enrollments[0].email).to eq('th******@gm***.com')
        expect(@patient_enrollments[1].email).to eq('th******@gm***.com')
        expect(@patient_enrollments[2].email).to eq('th******@gm***.com')
      end

      it 'returns formatted dates' do
        expect(@patient_enrollments[0].created_at).to eq('26-FEB-2015')
        expect(@patient_enrollments[1].created_at).to eq('25-FEB-2015')
        expect(@patient_enrollments[2].created_at).to eq('24-FEB-2015')
      end
    end
  end
end
