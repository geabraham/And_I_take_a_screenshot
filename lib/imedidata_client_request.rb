module IMedidataClient
  class Request
    def response
      imedidata_connection.send(http_method, path) { |req| req.body = request_body.to_json }
    end

    def http_method
      raise IMedidataClientError.new("No default http method. Please define an http method for the subclass.")
    end

    def request_body
      raise IMedidataClientError.new("No default request body. Please define an request body for the subclass.")
    end

    def imedidata_connection
      @connection ||= Faraday.new(url: IMED_BASE_URL) do |builder|
        builder.use MAuth::Faraday::RequestSigner, mauth_client: MAUTH_CLIENT
        builder.adapter Faraday.default_adapter
      end
    end
  end

  class SecurityQuestionsRequest < Request
    def self.required_attributes
      [:locale]
    end

    def initialize(attrs = {})
      @locale = attrs[:locale]
    end

    def request_body; end

    def path
      "api/v2/user_security_questions/#{@locale}.json"
    end

    def http_method
      :get
    end
  end
end