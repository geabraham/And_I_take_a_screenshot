require 'spec_helper'

describe 'Minotaur routes', type: :routing do
  describe 'ActivationCodes' do
    
    it 'has a root route' do
      expect(get('/')).to route_to('activation_codes#index')
    end
    
    it 'has an index route' do
      expect(get('/activation_codes')).to route_to('activation_codes#index')
    end
    
    it 'has an activate route' do
      expect(get('/activation_codes/3xD42f/activate')).to route_to(
      :controller =>'activation_codes',
      :id => '3xD42f', 
      :action => 'activate')
    end
  end
end