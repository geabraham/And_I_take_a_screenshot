require 'spec_helper'

describe 'PatientManagement Routes' do
  it 'has a patient management route' do
    expect(get('/patient_management')).to route_to(
      controller: 'patient_management',
      action: 'select_study_and_site')
  end

  it 'has an invite patient route' do
    expect(post('/patient_management/invite')).to route_to(
        controller: 'patient_management',
        action: 'invite')
  end

  it 'has an available subjects route' do
    study_uuid = 'f9d3a61c-5857-4b74-adce-723897c58fca'
    study_site_uuid = 'c5a26c85-6acc-42b5-b9b9-c366194aa7f0'
    path = "/patient_management/available_subjects?study_uuid=#{study_uuid}&study_site_uuid=#{study_site_uuid}"
    expect(get(path)).to route_to(controller: 'patient_management', action: 'available_subjects', study_uuid: study_uuid, study_site_uuid: study_site_uuid)
  end
end
