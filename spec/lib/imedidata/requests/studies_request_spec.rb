describe IMedidataClient::StudiesRequest do
  let(:user_uuid)           { SecureRandom.uuid }
  let(:required_attributes) { [:user_uuid] }
  let(:path)                { "/api/v2/users/#{user_uuid}/studies.json" }
  let(:http_method)         { :get }
  let(:subject)             { IMedidataClient::StudiesRequest.new(user_uuid: user_uuid) }

  describe '.required_attributes' do
    let(:subject) { IMedidataClient::StudiesRequest }
    it_behaves_like('class with required attributes')
  end

  include_examples('has expected path')
  include_examples('has expected http_method')
end
