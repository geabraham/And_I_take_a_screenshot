shared_examples_for 'class with required attributes' do
  it 'class with required attributes' do
    expect(subject.class.required_attributes).to eq(required_attributes)
  end
end

shared_examples_for 'has expected path' do
  it 'has expected path' do
    expect(subject.path).to eq(path)
  end
end

shared_examples_for 'has expected http_method' do
  it('has expected http_method') { expect(subject.http_method).to eq(http_method) }
end
