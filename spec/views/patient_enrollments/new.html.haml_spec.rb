require 'spec_helper'

describe 'patient_enrollments/new.html.haml' do
  let(:html) { view.content_for(:page_body) }
  before do
    assign(:tou_dpn_agreement_body, '<body>Consider yourself warned.</body>')
    assign(:security_questions, [['What?', 1], ['Who?', 2]])
    assign(:patient_enrollment, PatientEnrollment.new)
    assign(:patient_enrollment_uuid, SecureRandom.uuid)
    render
  end

  context 'tou_dpn_agreement page' do
    it 'contains tou dpn agreement' do
      expect(html).to have_text('Consider yourself warned.')
    end

    it 'contains an agree button' do
      expect(html).to have_selector('#next-agree', text: 'I agree')
    end

  end

  context 'email page' do
    it 'contains an email input' do
      expect(html).to have_field('Email', type: 'email', exact: true)
    end

    it 'contains an email confirmation input' do
      expect(html).to have_field('Re-enter Email', type: 'email', exact: true)
    end

    it 'contains a validation error div' do
      expect(html).to have_selector('#email div.validation_error', text: '')
    end
    it 'contains a next button' do
      expect(html).to have_selector('#next-email', text: 'Next')
    end
  end

  context 'password page' do
    it 'contains a password input' do
      expect(html).to have_field('Password', type: 'password', exact: true)
    end

    it 'contains a password confirmation input' do
      expect(html).to have_field('Re-enter Password', type: 'password', exact: true)
    end

    it 'contains a validation error div' do
      expect(html).to have_selector('#password div.validation_error', text: '')
    end
    it 'contains a next button' do
      expect(html).to have_selector('#next-password', text: 'Next')
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

    it 'contains a submit button' do
      expect(html).to have_selector('input[@type="submit"][@value="Create my account"]')
    end

    describe 'form html' do
      let(:remote_form_selector) { 'form[@data-remote="true"]' }

      context 'when in-app browser' do
        before { assign(:in_app_browser, true); render }

        it 'data-remote set to true' do
          expect(html).to have_selector(remote_form_selector)
        end
      end

      context 'when other browser' do
        before { assign(:in_app_browser, nil); render }

        it 'data-remote not present' do
          expect(html).not_to have_selector(remote_form_selector)
        end
      end
    end
  end
  
  context 'shared controls' do
    
  
    # it 'contains a back arrow' do
    #   expect(html).to have_selector('a.back_arrow', text: 'Back')
    # end
  
    
    # it 'contains an agree button' do
    #   expect(html).to have_selector('#agree-button', text: 'I agree')
    # end

    
  end
end
