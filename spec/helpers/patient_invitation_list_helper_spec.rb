require 'spec_helper'

describe PatientInvitationListHelper do
  let(:test_class)      { Class.new { extend PatientInvitationListHelper } }
  let(:initials)        { 'TD' }
  let(:email)           { 'the-dude@gmail.com' }
  let(:activation_code) { 'ABCDEFG' }
  let(:subject_id)      { 'Subject-001' }
  let(:state)           { 'invited' }
  let(:created_at)      { '2015-02-26 18:47:07 UTC' }
  let(:patient_enrollment_attributes) do
    {
      initials: initials,
      email: email,
      activation_code: activation_code,
      subject_id: subject_id,
      state: state,
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
      let(:created_at_2)           { '2015-02-25 18:47:07 UTC' }
      let(:created_at_3)           { '2015-02-24 18:47:07 UTC' }
      let(:patient_enrollment_2)   do
        build :patient_enrollment, patient_enrollment_attributes.merge(created_at: created_at_2)
      end
      let(:patient_enrollment_3)   do
        build :patient_enrollment, patient_enrollment_attributes.merge(created_at: created_at_3)
      end

      before do
        allow(PatientEnrollment).to receive(:by_study_and_study_site)
          .and_return([patient_enrollment_2, patient_enrollment_3, patient_enrollment_1])
        @patient_enrollments = test_class.fetch_patient_enrollments
      end

      it 'returns anonymized emails' do
        expect(@patient_enrollments[0][:email]).to eq('th******@gm***.com')
        expect(@patient_enrollments[1][:email]).to eq('th******@gm***.com')
        expect(@patient_enrollments[2][:email]).to eq('th******@gm***.com')
      end

      it 'returns formatted dates in reverse created at order' do
        expect(@patient_enrollments[0][:created_at]).to eq('26-FEB-2015')
        expect(@patient_enrollments[1][:created_at]).to eq('25-FEB-2015')
        expect(@patient_enrollments[2][:created_at]).to eq('24-FEB-2015')
      end
    end
  end
end
