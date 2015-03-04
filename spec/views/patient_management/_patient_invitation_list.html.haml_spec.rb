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
    it 'is inside the patient list div' do
      expect(rendered).to have_selector('#patient-list table')
    end

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

    describe 'controls' do
      it ('has a place for validation errors') { expect(rendered).to have_selector('.validation_error') }
      it ('has a first link')                  { expect(rendered).to have_selector('a.disabled.first', text: 'first') }
      it ('has a previous link')               { expect(rendered).to have_selector('a.disabled.previous', text: 'previous') }
      it ('has a form for the page')           { expect(rendered).to have_selector('form#page-form') }
      it ('has an input for the current page') { expect(rendered).to have_selector('input#current-page') }
      it ('has a place for total pages')       { expect(rendered).to have_selector('#total-pages') }
      it ('has a next link')                   { expect(rendered).to have_selector('a.disabled.next', text: 'next') }
      it ('has a last link')                   { expect(rendered).to have_selector('a.disabled.last', text: 'last') }
    end

    describe 'hidden no patient enrollments message' do
      it 'has the hidden message' do
        expect(rendered).to have_selector('#none-message.hidden', text: 'There are currently no patient enrollments for this study.')
      end
    end
  end
end
