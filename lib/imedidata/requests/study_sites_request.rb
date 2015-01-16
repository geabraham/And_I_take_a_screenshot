# request = IMedidataClient::StudySitesRequest.new(user_uuid: '0e39dd40-9fe2-11df-a531-12313900d531', study_uuid: 'fda08b50-9fe1-11df-a531-12313900d531')
#
# pp JSON.parse(request.response.body)
# {"study_sites"=>
#   [{"name"=>"Alfred Hospital",
#     "number"=>"1234",
#     "site_number"=>"1234",
#     "uuid"=>"161332d2-9fe2-11df-a531-12313900d531",
#     ...
#
module IMedidataClient
  class StudySitesRequest < Request
    def self.required_attributes
      [:user_uuid, :study_uuid]
    end

    def initialize(attrs = {})
      raise argument_error unless self.class.required_attributes.all? {|p| attrs[p].present? }
      @user_uuid, @study_uuid = attrs[:user_uuid], attrs[:study_uuid]
    end

    def path
      "/api/v2/users/#{@user_uuid}/studies/#{@study_uuid}/study_sites.json"
    end

    def http_method
      :get
    end 
  end
end
