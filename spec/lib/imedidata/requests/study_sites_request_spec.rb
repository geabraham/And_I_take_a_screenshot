describe IMedidataClient::StudySitesRequest do
  let(:user_uuid)           { SecureRandom.uuid }
  let(:study_uuid)    { SecureRandom.uuid }
  let(:study_sites_request) { IMedidataClient::StudySitesRequest.new(user_uuid: user_uuid, study_uuid: study_uuid) }

  describe '.required_attributes' do
    it('returns user_uuid') { expect(IMedidataClient::StudySitesRequest.required_attributes).to eq([:user_uuid, :study_uuid]) }
  end

  describe '#path' do
    it 'is the right path' do
      expect(study_sites_request.path).to eq("/api/v2/users/#{user_uuid}/studies/#{study_uuid}/study_sites.json")
    end
  end

  describe 'http_method' do
    it('is get') { expect(study_sites_request.http_method).to eq(:get) }
  end
end
