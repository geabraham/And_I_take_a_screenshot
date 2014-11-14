shared_examples_for 'includes ActiveModel::Model' do |initialize_args|

  describe '#initialize' do
    subject { double described_class }

    context 'when argument itself is nil' do
      it 'does not raise an error' do
        expect { described_class.new(nil) }.to_not raise_error
      end
    end

    context 'when argument is not nil' do
      let(:args_hash) { initialize_args.each_with_object({}) { |x, hash| hash[x.to_sym] = "test #{x}" } }
      let(:object)    { described_class.new(args_hash) }

      it 'assigns all values passed' do
        args_hash.each do |key, value|
          expect(object.send(key)).to eq value
        end
      end
    end
  end

  describe '.persisted?' do
    let(:klass) { described_class.new }

    it 'returns false' do
      expect(klass.persisted?).to be false
    end

  end
end
