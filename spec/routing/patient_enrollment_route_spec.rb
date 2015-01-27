require 'spec_helper'

describe 'PatientEnrollment Routes' do
  it 'has a GET new route' do
    expect(get('/patient_enrollments/new')).to route_to('patient_enrollments#new')
  end

  it 'has a POST create route' do
    expect(post('/patient_enrollments/register')).to route_to('patient_enrollments#register')
  end
end
