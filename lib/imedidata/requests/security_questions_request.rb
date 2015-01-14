module IMedidataClient
  class SecurityQuestionsRequest < Request
    def self.required_attributes
      [:locale]
    end

    def initialize(attrs = {})
      raise argument_error unless self.class.required_attributes.all? {|p| attrs[p].present? }
      @locale = attrs[:locale]
    end

    def path
      "/api/v2/user_security_questions/#{@locale}.json"
    end

    def http_method
      :get
    end
  end
end
