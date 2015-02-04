require 'spec_helper'

describe 'patient_management/error' do
  let(:html) { view.content_for(:page_body) }
  let(:error_message) do
    'The link or URL you used either doesn\'t exist or you don\'t have permission to view it.'
  end

  before do
    assign(:error_message, error_message)
    render
  end

  it 'has the error message' do
    expect(html).to have_content(error_message)
  end
end
