require 'spec_helper'

describe 'activation_codes/_activation_code.html.haml' do
  describe 'enter code' do
    before do
      render
    end
    
    it "displays the expected 'Please enter code' label" do
      expect(rendered).to have_selector('.code_enter')
    end
    
    it 'displays the expected instruction text' do
      expect(rendered).to have_selector('.code_instruction')
    end
    
    it 'displays the activation code input fields' do
      expect(rendered).to have_selector('.code')
    end
  end
end