describe IMedidataClient::SecurityQuestionsRequest do
  let(:locale)              { 'kor' }
  let(:required_attributes) { [:locale] }
  let(:path)                { "/api/v2/user_security_questions/#{locale}.json" }
  let(:http_method)         { :get }
  let(:subject)             { IMedidataClient::SecurityQuestionsRequest.new(locale: locale) }

  describe '.required_attributes' do
    let(:subject) { IMedidataClient::SecurityQuestionsRequest }
    it_behaves_like('class with required attributes')
  end

  include_examples('has expected path')
  include_examples('has expected http_method')
end
