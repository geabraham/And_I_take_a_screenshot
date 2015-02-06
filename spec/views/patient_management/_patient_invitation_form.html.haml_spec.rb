require 'spec_helper'

describe 'patient_management/_patient_invitation_form.html.haml' do
  let(:tou_dpn_agreement_1) { {text: "Israel / Arabic", value: "{\"language_code\":\"ara\",\"country_code\":\"ISR\"}"}}
  let(:tou_dpn_agreement_2) { {text: "Czech Republic / Czech", value: "{\"language_code\":\"cze\",\"country_code\":\"CZE\"}"}}
  let(:tou_dpn_agreements)  { [tou_dpn_agreement_1.values, tou_dpn_agreement_2.values]}
  let(:available_subjects)  { arr = []; 5.times {|i| arr << ["Subject-00#{i}", "Subject-00#{i}"]}; arr }
  let(:study_site_name)     { 'Starship Enterprise' }

  before do
    assign(:tou_dpn_agreements, tou_dpn_agreements)
    assign(:available_subjects, available_subjects)
    assign(:study_site_name, study_site_name)
    # Otherwise infers the action to be index, which doesn't exist
    #
    controller.request.path_parameters[:action] = 'select_study_and_site'
    render
  end

  describe 'basic page' do
    it('has a prompt') { expect(rendered).to have_text("Add a patient to #{study_site_name}.") }
    it('has a disabled invite button') { expect(rendered).to have_selector("input#invite-button[@disabled='disabled']") }
  end

  describe 'available subjects dropdown' do
    it 'has options with the expected text and values' do
      expect(rendered).to have_selector("option[@value='']", text: 'Subject Identifier')
      expect(rendered).to have_selector("option[@value='Subject-001']", text: 'Subject-001')
    end

    it 'has all the subjects and no extras' do
      expect(rendered).to have_css('#_patient_management_invite_subject_identifier option', count: 6)
    end
  end

  describe 'tou_dpn_agreements dropdown' do
    it 'has all the options with the expected text and values' do
      expect(rendered).to have_selector("option[@value='']", text: 'Country / Language')
      expect(rendered).to have_selector("option[@value='#{tou_dpn_agreement_1[:value]}']", text: tou_dpn_agreement_1[:text])
      expect(rendered).to have_selector("option[@value='#{tou_dpn_agreement_2[:value]}']", text: tou_dpn_agreement_2[:text])
    end
  end

  it 'has a subject initials field' do
    expect(rendered).to have_selector('input#_patient_management_invite_email')
  end

  it 'has a subject email field' do
    expect(rendered).to have_selector('input#_patient_management_invite_initials')
  end

  describe 'submit button' do
    it('exists') { expect(rendered).to have_selector('input[@type="submit"][@value="Invite"]')}
  end
end
