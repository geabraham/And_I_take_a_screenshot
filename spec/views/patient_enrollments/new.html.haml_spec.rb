require 'rails_helper'

describe 'patient_enrollments/new.html.haml' do
  let(:html) { view.content_for(:page_body) }
  before do
    assign(:security_questions, [['What?', 1], ['Who?', 2]])
    assign(:patient_enrollment, PatientEnrollment.new)
    render
  end

  it 'contains an email input' do
    expect(html).to have_field('E-mail Address', type: 'text', exact: true)
  end

  it 'contains an email confirmation input' do
    expect(html).to have_field('Confirm E-mail Address', type: 'text', exact: true)
  end

  it 'contains a password input' do
    expect(html).to have_field('Password', type: 'password', exact: true)
  end

  it 'contains a password confirmation input' do
    expect(html).to have_field('Confirm Password', type: 'password', exact: true)
  end

  it 'contains a security question dropdown' do
    # TODO: Test that the blank option is selected. "selected: ''" and "selected: nil" didn't work.
    expect(html).to have_select('Security Question', options: ['', 'What?', 'Who?'])
  end

  it 'contains a security answer input' do
    expect(html).to have_field('Answer', type: 'text', exact: true)
  end

  it 'contains a submit button' do
    expect(html).to have_selector('input[@type="submit"][@value="Submit"]')
  end
end
