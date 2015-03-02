require 'spec_helper'

describe 'patient_management/_patient_invitation_list' do
  let(:patient_enrollments) { [] }

  before do
    assign(:patient_enrollments, patient_enrollments)
    # Otherwise infers the action to be index, which doesn't exist
    #
    controller.request.path_parameters[:action] = 'select_study_and_site'
    render
  end

  describe 'table' do
    it 'has the right headers' do
      expect(rendered).to have_selector('th', text: 'Added on')
      expect(rendered).to have_selector('th', text: 'Subject I.D.')
      expect(rendered).to have_selector('th', text: 'Email')
      expect(rendered).to have_selector('th', text: 'Initials')
      expect(rendered).to have_selector('th', text: 'Activation Code')
      expect(rendered).to have_selector('th', text: 'Registered')
    end

    it 'displays the total patient enrollments count' do
      expect(rendered).to have_selector('#total-count', text: 0)
    end

    describe 'pagination links' do
      it 'has the right pagination links' do
        ['10', '25', '50', '100'].each do |pp|
          expect(rendered).to have_selector("a##{pp}-pp", text: pp)
        end
      end

      it 'has the right per page selected and disabled' do
        expect(rendered).to have_selector("a#25-pp.disabled.selected")
      end
    end

    describe 'navigation controls' do
      it 'has a first link' do
        expect(rendered).to have_selector('a.disabled.first', text: 'first')
      end

      it 'has a previous link' do
        expect(rendered).to have_selector('a.disabled.previous', text: 'previous')
      end

      it 'has an input for the current page' do
        expect(rendered).to have_selector('input#current-page', text: 'previous')
      end

      it 'has a next link' do
        expect(rendered).to have_selector('a.disabled.next', text: 'next')
      end

      it 'has a last link' do
        expect(rendered).to have_selector('a.disabled.last', text: 'last')
      end
    end
  end
end
