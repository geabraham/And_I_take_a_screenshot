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
    
    it 'displays the activation code input fields' do
      expect(html).to have_selector("input#code-1")
      expect(html).to have_selector("input#code-2")
      expect(html).to have_selector("input#code-3")
      expect(html).to have_selector("input#code-4")
      expect(html).to have_selector("input#code-5")
      expect(html).to have_selector("input#code-6")
    end
  end
end
