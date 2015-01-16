describe IMedidataClient::StudySitesRequest do
  let(:user_uuid)           { SecureRandom.uuid }
  let(:study_uuid)          { SecureRandom.uuid }
  let(:required_attributes) { [:user_uuid, :study_uuid] }
  let(:path)                { "/api/v2/users/#{user_uuid}/studies/#{study_uuid}/study_sites.json" }
  let(:http_method)         { :get }
  let(:subject)             { IMedidataClient::StudySitesRequest.new(user_uuid: user_uuid, study_uuid: study_uuid) }

  describe '.required_attributes' do
    let(:subject) { IMedidataClient::StudySitesRequest }
    it_behaves_like('class with required attributes')
  end

  include_examples('has expected path')
  include_examples('has expected http_method')
end
