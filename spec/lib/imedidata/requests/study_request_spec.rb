require 'spec_helper'

describe IMedidataClient::StudyRequest do
  let(:study_uuid)          { SecureRandom.uuid }
  let(:required_attributes) { [:study_uuid] }
  let(:path)                { "/api/v2/studies/#{study_uuid}.json" }
  let(:http_method)         { :get }
  let(:subject)             { IMedidataClient::StudyRequest.new(study_uuid: study_uuid) }

  describe '.required_attributes' do
    let(:subject) { IMedidataClient::StudyRequest }
    it_behaves_like('class with required attributes')
  end

  include_examples('has expected path')
  include_examples('has expected http_method')
end
