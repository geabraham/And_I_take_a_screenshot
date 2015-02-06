require 'spec_helper'

describe 'patient_management/error' do
  let(:html) { view.content_for(:page_body) }
  let(:error_message) do
    "404 Not Found " <<
    "The link or URL you used either doesn't exist or you don't have permission to view it. " <<
    "For further assistance, please contact the Help Desk or return to the Home Page."
  end

  context 'when status code is defined' do
    before do
      render template: 'patient_management/error', locals: {status_code: 404}
    end

    it 'has the error message' do
      expect(html).to have_content(error_message)
    end
  end

  context 'when status code is not defined' do
    let(:error_message) do
      "500 System Error " <<
      "The link or URL you used resulted in a system error, " <<
      "and we can't display the information you requested. " <<
      "For further assistance, please contact the Help Desk or return to the Home Page."
    end
    before { render template: 'patient_management/error' }

    it 'has the error message' do
      expect(html).to have_content(error_message)
    end
  end
end
