require 'spec_helper'

describe 'activation_codes/index.html.haml' do
  let(:html) { view.content_for(:page_body) }
  describe 'enter code' do
    before do
      render
    end
    
    it "displays the expected 'Please enter code' label" do
      expect(html).to have_selector('h3', text: 'Please enter your activation code')
    end
    
    it 'displays the expected instruction text' do
      expect(html).to have_selector('.activation-code-content p', text: 'If you have already registered, please return to the Patient Cloud App. If you have not registered and do not have an activation code or email invite please contact your doctor.')
    end
    
    it 'displays the activation code input field' do
      expect(html).to have_selector("input#code")
    end
    
    it 'displays the Activate button' do
      expect(html).to have_selector('#activate-button')
    end
  end
end
