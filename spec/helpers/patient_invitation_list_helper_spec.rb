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

  describe '#format_and_anonymize' do
    subject { patient_enrollment_1 }
    before  { test_class.format_and_anonymize(patient_enrollment_1) }

    context 'with all attributes' do
      its(:uuid)            { is_expected.to eq(uuid) }
      its(:initials)        { is_expected.to eq(initials) }
      its(:email)           { is_expected.to eq('th******@gm***.com') }
      its(:enrollment_type) { is_expected.to eq(enrollment_type) }
      its(:activation_code) { is_expected.to eq(activation_code) }
      its(:study_uuid)      { is_expected.to eq(study_uuid) }
      its(:study_site_uuid) { is_expected.to eq(study_site_uuid) }
      its(:subject_id)      { is_expected.to eq(subject_id) }
      its(:state)           { is_expected.to eq('Invited') }
      its(:tou_accepted_at) { is_expected.to eq(tou_accepted_at) }
      its(:created_at)      { is_expected.to eq('26-FEB-2015') }
    end
      
    context 'with missing email' do
      let(:missing_email_attributes) { patient_enrollment_attributes.merge!(email: nil) }
      let(:patient_enrollment_1)     { build :patient_enrollment, missing_email_attributes }

      its(:email) { is_expected.to eq(nil) }
    end

    context 'with missing created at' do
      let(:missing_created_at_attributes) { patient_enrollment_attributes.merge!(created_at: nil) }
      let(:patient_enrollment_1)          { build :patient_enrollment, missing_created_at_attributes }

      its(:created_at) { is_expected.to eq(nil) }
    end

    context 'with missing state' do
      let(:missing_state_attributes) { patient_enrollment_attributes.merge!(state: nil) }
      let(:patient_enrollment_1)     { build :patient_enrollment, missing_state_attributes }

      its(:state) { is_expected.to eq(nil) }
    end

    describe 'anonymized email' do
      context 'when not an email' do
        let(:email) { 'some-weird-string' }
        its(:email) { is_expected.to eq('so***************@***.') }
      end

      context 'when an empty string' do
        let(:email) { '' }
        its(:email) { is_expected.to eq('') }
      end

      context 'when a short user' do
        let(:email) { 'a@g.com' }
        its(:email) { is_expected.to eq('a***@g***.com') }
      end
    end
  end

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
