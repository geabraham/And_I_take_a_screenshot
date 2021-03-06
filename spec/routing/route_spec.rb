require 'spec_helper'

describe 'Minotaur routes', type: :routing do
  describe 'basic routes' do
    it 'has a logout route' do
      expect(get('/logout')).to route_to('application#logout')
    end

    it 'has a study sites route' do
      expect(get('/study_sites')).to route_to(
        controller: 'study_sites',
        action: 'index')
    end

    it 'catches routing errors' do
      expect(get('/bad_path')).to route_to(
        controller: 'application',
        action: 'routing_error',
        path: 'bad_path')
    end
  end

  describe 'ActivationCodes' do
    
    it 'has a root route' do
      expect(get('/')).to route_to('activation_codes#index')
    end
    
    it 'has an index route' do
      expect(get('/activation_codes')).to route_to('activation_codes#index')
    end

    it 'has an activate route' do
      expect(get('/activation_codes/3xD42f/validate')).to route_to(controller: 'activation_codes', id: '3xD42f', action: 'validate')
    end
  end
end
