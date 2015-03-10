require 'spec_helper'

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

  describe 'dismiss browser script' do
    context 'when in app browser' do
      before do
        assign(:in_app_browser, true)
        render
      end

      it 'includes a script' do
        expect(html).to have_content("setTimeout(function() { window.location.assign(\"patient-cloud:registration-complete\") }, 5000);")
      end
    end

    context 'when not in app browser' do
      it 'does not include the script' do
        expect(html).not_to have_content("setTimeout(function() { window.location.assign(\"patient-cloud:registration-complete\") }, 5000);")
      end
    end
  end
end
