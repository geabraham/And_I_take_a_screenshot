shared_examples_for 'returns expected status' do
  it 'returns expected status' do
    send(verb, action, params)
    expect(response.status).to eq(expected_status_code)
  end
end

shared_examples_for 'assigns the expected instance variables' do
  it 'assigns the expected instance variables' do
    send(verb, action, params)
    expected_ivars.each do |eivar|
      expect(assigns(eivar[:name])).to eq(eivar[:value])
    end
  end
end

shared_examples_for 'returns expected body' do
  it 'returns expected body' do
    send(verb, action, params)
    expect(response.body).to eq(expected_body)
  end
end

shared_examples_for 'renders expected template' do
  it 'renders expected template' do
    send(verb, action, params)
    expect(response).to render_template(expected_template)
  end
end

shared_examples_for 'returns expected error response body' do
  it 'returns expected error response body' do
    send(verb, action, params)
    expect(response.body).to eq(error_response_body)
  end
end

shared_examples_for 'assigns an ivar to its expected value' do |ivar, expected_value|
  it 'assigns an ivar to its expected value' do
    expect(assigns(ivar)).to eq(expected_value)
  end
end