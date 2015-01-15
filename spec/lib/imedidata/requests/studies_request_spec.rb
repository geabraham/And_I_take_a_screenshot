describe IMedidataClient::StudiesRequest do
  let(:user_uuid)       { SecureRandom.uuid }
  let(:studies_request) { IMedidataClient::StudiesRequest.new(user_uuid: user_uuid) }

  describe '.required_attributes' do
    it('are user uuid') { expect(IMedidataClient::StudiesRequest.required_attributes).to eq([:user_uuid]) }
  end

  describe '#path' do
    it 'is the right path' do
      expect(studies_request.path).to eq("/api/v2/users/#{user_uuid}/studies.json")
    end
  end

  describe 'http_method' do
    it('is get') { expect(studies_request.http_method).to eq(:get) }
  end
end
