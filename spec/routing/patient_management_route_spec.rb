require 'spec_helper'

describe 'PatientManagement Routes' do
  it 'has a patient management route' do
    expect(get('/patient_management')).to route_to(
      controller: 'patient_management',
      action: 'select_study_and_site')
  end

  it 'has an invite patient route' do
    expect(post('/patient_management/invite_patient')).to route_to(
        controller: 'patient_management',
        action: 'invite_patient')
  end
end