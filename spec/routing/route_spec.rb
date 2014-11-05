require 'rspec'
require 'rails_helper'

RSpec.describe 'Minotaur routes', type: :routing do
  describe 'PatientRegistrations' do
    
    it 'has a root route' do
      expect(get('/')).to route_to('patient_registrations#index')
    end
    
    it 'has an index route' do
      expect(get('/patient_registrations')).to route_to('patient_registrations#index')
    end
  end
end