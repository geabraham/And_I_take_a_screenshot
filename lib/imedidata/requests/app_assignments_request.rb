# aar = IMedidataClient::AppAssignmentsRequest.new({
#   user_uuid: '06acf77e-c2fe-4bcd-b44a-dd2fea8bd1a3',
#   study_uuid: 'b715db56-7f28-4b74-89f4-b502cf5a1d45'})
# 
# JSON.parse(aar.response.body)
#
# {"apps"=>
#   [{"name"=>"Patient Web Registration",
#     "api_id"=>"ddd9a496-0a1c-48bf-925e-496ee64ddf48",
#     "uuid"=>"ddd9a496-0a1c-48bf-925e-496ee64ddf48",
#     ...
#
module IMedidataClient
  class AppAssignmentsRequest < Request
    def self.required_attributes
      [:user_uuid, :study_uuid]
    end

    def initialize(attrs = {})
      raise argument_error unless self.class.required_attributes.all? {|p| attrs[p].present? }
      @user_uuid, @study_uuid = attrs[:user_uuid], attrs[:study_uuid]
    end

    def path
      "/api/v2/users/#{@user_uuid}/studies/#{@study_uuid}/apps.json"
    end

    def http_method
      :get
    end 
  end
end
