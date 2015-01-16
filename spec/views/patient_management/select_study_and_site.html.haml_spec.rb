require 'spec_helper'

describe 'patient_management/select_study_and_site.html.haml' do
  let(:html)             { view.content_for(:page_body) }
  let(:study_or_studies) { [] }
  let(:study_sites)      { [] }

  before do
    assign(:study_or_studies, study_or_studies)
    assign(:study_sites, study_sites)
    render
  end

  describe 'basic page' do
    it('has the right title') { expect(html).to have_text('Patient Management') }
    it('has a prompt') { expect(html).to have_text('Please choose a study and a site.') }

    it 'contains a studies dropdown' do
      expect(html).to have_select('patient_management_study')
    end

    it 'has a study sites dropdown' do
      expect(html).to have_select('patient_management_study_site')
    end
  end

  context 'with studies' do
    let(:study1_title)     { 'Incorporating Avocados in Meals' }
    let(:study1_uuid)      { SecureRandom.uuid }
    let(:study2_title)     { 'Immune Benefits of Coffee' }
    let(:study2_uuid)      { SecureRandom.uuid }
    let(:study_or_studies) { [[study1_title, study1_uuid], [study2_title, study2_uuid]] }

    it 'has all the options with the expected text and values' do
      expect(html).to have_selector("option[@value='']", text: 'Study')
      expect(html).to have_selector("option[@value='#{study1_uuid}']", text: study1_title)
      expect(html).to have_selector("option[@value='#{study2_uuid}']", text: study2_title)
    end
  end

  context 'with study sites' do
    let(:study_site1_title) { 'Incorporating Avocados in Meals' }
    let(:study_site1_uuid)  { SecureRandom.uuid }
    let(:study_site2_title) { 'Immune Benefits of Coffee' }
    let(:study_site2_uuid)  { SecureRandom.uuid }
    let(:study_sites)       { [[study_site1_title, study_site1_uuid], [study_site2_title, study_site2_uuid]] }

    it 'has all the options with the expected text and values' do
      expect(html).to have_selector("option[@value='']", text: 'Site')
      expect(html).to have_selector("option[@value='#{study_site1_uuid}']", text: study_site1_title)
      expect(html).to have_selector("option[@value='#{study_site2_uuid}']", text: study_site2_title)
    end
  end

  describe 'submit button' do
    it('exists') { expect(html).to have_selector('input[@type="submit"][@value="Launch"]')}
  end
end
