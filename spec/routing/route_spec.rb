require 'rails_helper'

describe 'Minotaur routes', type: :routing do
  describe 'ActivationCodes' do
    
    it 'has a root route' do
      expect(get('/')).to route_to('activation_codes#index')
    end
    
    it 'has an index route' do
      expect(get('/activation_codes')).to route_to('activation_codes#index')
    end
    
    it 'has an activate route' do
      expect(post('/activation_codes/0xD42f/activate')).to route_to(
      :controller =>'activation_codes',
      :id => '0xD42f', 
      :action => 'activate')
    end
  end
end