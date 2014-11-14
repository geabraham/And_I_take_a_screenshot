shared_examples_for 'has accessors for' do |described_attributes|
  attributes = described_attributes.is_a?(Array) ? described_attributes : [described_attributes]

  attributes.each do |described_attribute|
    context "when #{described_attribute} has not been assigned" do
      it 'does not raise an exception' do
        expect{subject.send("#{described_attribute}")}.to_not raise_error
      end
    end

    context "when #{described_attribute} has been assigned" do
      before { subject.send("#{described_attribute}=", 'test attr') }

      it 'returns the assigned value' do
        expect(subject.send("#{described_attribute}")).to eq 'test attr'
      end
    end
  end
end
