require 'spec_helper'

describe 'error' do
  before do
    assign(:error_message, 'The link or URL you used either doesn\'t exist ' <<
      'or you don\'t have permission to view it.')
    render
  end

  it 'has the error message' do
    expect(rendered).to have_content(@error_message)
  end
end
