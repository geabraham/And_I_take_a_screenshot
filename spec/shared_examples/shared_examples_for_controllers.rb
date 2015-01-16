shared_examples_for 'returns expected status' do
  it 'returns expected status' do
    send(verb, action, params)
    expect(response.status).to eq(expected_status_code)
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
