# request = IMedidataClient::StudyRequest.new(
#   user_uuid: '0e39dd40-9fe2-11df-a531-12313900d531',
#   study_uuid: 'fda08b50-9fe1-11df-a531-12313900d531')
#
# pp JSON.parse(request.response.body)
# {"study"=>
#   {"name"=>"Globalix",
#    "uuid"=>"fda08b50-9fe1-11df-a531-12313900d531",
#    "mcc_study_uuid"=>"",
#    "oid"=>"12347",
#
module IMedidataClient
  class StudyRequest < Request
    def self.required_attributes
      [:study_uuid]
    end

    def initialize(attrs = {})
      raise argument_error unless self.class.required_attributes.all? {|p| attrs[p].present? }
      @study_uuid = attrs[:study_uuid]
    end

    def path
      "/api/v2/studies/#{@study_uuid}.json"
    end

    def http_method
      :get
    end 
  end
end
