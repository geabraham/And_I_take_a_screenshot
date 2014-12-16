require 'rails_helper'

describe 'patient_enrollments/download.html.haml' do
  let(:html) { view.content_for(:page_body) }
  before do
    render
  end
  
  it 'contains a Play Store download link' do
    expect(html).to have_selector('a.download-android')
  end
  
  it 'contains an iTunes Store download link' do
    expect(html).to have_selector('a.download-ios')
  end
  
  context 'shared controls' do
    it 'contains a back arrow' do
      expect(html).to have_selector('a.back_arrow', text: 'Back')
    end
  end
end