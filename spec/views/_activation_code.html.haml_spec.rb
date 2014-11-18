require 'spec_helper'

describe 'activation_codes/_activation_code.html.haml' do
  describe 'enter code' do
    before do
      render
    end
    
    it "displays the expected 'Please enter code' label" do
      expect(rendered).to have_selector('h2.code_enter', text: 'Please enter your activation code')
    end
    
    it 'displays the expected instruction text' do
      expect(rendered).to have_selector('div.code_instruction', text: 'If you have already registered, please return to the Patient Cloud App. If you have not registered and do not have an activation code or email invite please contact your doctor.')
    end
    
    it 'displays the activation code input fields' do
      expect(rendered).to have_selector("input#code-1")
      expect(rendered).to have_selector("input#code-2")
      expect(rendered).to have_selector("input#code-3")
      expect(rendered).to have_selector("input#code-4")
      expect(rendered).to have_selector("input#code-5")
      expect(rendered).to have_selector("input#code-6")
    end
  end
end
