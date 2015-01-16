shared_examples_for 'class with required attributes' do
  its(:required_attributes) { is_expected.to eq(required_attributes) }
end

shared_examples_for 'has expected path' do
  its(:path) { is_expected.to eq(path) }
end

shared_examples_for 'has expected http_method' do
  its(:http_method) { is_expected.to eq(http_method) }
end
