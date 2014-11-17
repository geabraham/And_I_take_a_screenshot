require 'rails_helper'

describe 'PatientEnrollment Routes' do
  it 'has a GET new route' do
    expect(get('/patient_enrollments/new')).to route_to('patient_enrollments#new')
  end

  it 'has a POST create route' do
    expect(post('/patient_enrollments')).to route_to('patient_enrollments#create')
  end
end
