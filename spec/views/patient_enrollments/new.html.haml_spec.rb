require 'rails_helper'

describe 'patient_enrollments/new.html.haml' do
  let(:html) { view.content_for(:page_body) }
  before do
    assign(:tou_dpn_agreement_html, '<html><body>Consider yourself warned.</body></html>')
    assign(:security_questions, [['What?', 1], ['Who?', 2]])
    assign(:patient_enrollment, PatientEnrollment.new)
    render
  end
  
  context 'carousel markup' do
    it 'has auto-scroll disabled' do
      expect(html).to have_selector('div.carousel.slide#registration-details[@data-interval="false"]')
    end
  end
  
  context 'tou_dpn_agreement page' do
    it 'contains tou dpn agreement' do
      expect(html).to have_text('Consider yourself warned.')
    end
  end

  context 'email page' do
    it 'contains an email input' do
      expect(html).to have_field('Email', type: 'text', exact: true)
    end
    
    it 'contains an email confirmation input' do
      expect(html).to have_field('Re-enter Email', type: 'text', exact: true)
    end
    
    it 'contains a validation error div' do
      expect(html).to have_selector('#email div.validation_error', text: '')
    end
  end

  context 'password page' do
    it 'contains a password input' do
      expect(html).to have_field('Password', type: 'password', exact: true)
    end

    it 'contains a password confirmation input' do
      expect(html).to have_field('Confirm Password', type: 'password', exact: true)
    end
    
    it 'contains a validation error div' do
      expect(html).to have_selector('#password div.validation_error', text: '')
    end
  end
  
  context 'security question page' do
    it 'contains a security question dropdown' do
      # TODO: Test that the blank option is selected. "selected: ''" and "selected: nil" didn't work.
      expect(html).to have_select('Security Question', options: ['Security Question', 'What?', 'Who?'])
    end

    it 'contains a security answer input' do
      expect(html).to have_field('Security Answer', type: 'text', exact: true)
    end
  end
  
  context 'shared controls' do
    it 'contains a submit button' do
      expect(html).to have_selector('input[@type="submit"][@value="Create account"]')
    end
  
    it 'contains a back arrow' do
      expect(html).to have_selector('a.back_arrow', text: 'Back')
    end
  
    it 'contains a next button' do
      expect(html).to have_selector('#next-button', text: 'I agree')
    end
  end
end
