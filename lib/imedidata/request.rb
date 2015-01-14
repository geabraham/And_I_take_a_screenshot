module IMedidataClient
  class Request
    def self.required_attributes
      []
    end

    def response
      if defined?(request_body) && request_body.present?
        imedidata_connection.send(http_method, path) { |req| req.body = request_body.to_json }
      else
        imedidata_connection.send(http_method, path)
      end
    end

    def http_method
      raise IMedidataClientError.new("No default http method. Please define an http method for the subclass.")
    end

    def path
      raise IMedidataClientError.new("No default request path. Please define a request path for the subclass.")
    end

    def imedidata_connection
      @connection ||= Faraday.new(url: IMED_BASE_URL) do |builder|
        builder.use MAuth::Faraday::RequestSigner, mauth_client: MAUTH_CLIENT
        builder.adapter Faraday.default_adapter
      end
    end

    def argument_error
      RequestArgumentError.new("Invalid arguments. Please provide #{self.class.required_attributes.join(', ')}.")
    end

    class RequestArgumentError < ArgumentError; end
  end
end
