# request = IMedidataClient::StudiesRequest.new(user_uuid: '06acf77e-c2fe-4bcd-b44a-dd2fea8bd1a3')
#
# pp JSON.parse(request.response.body)
# {"studies"=>
#   [{"name"=>"AimeeLocalTestStudy",
#     "uuid"=>"276329b5-ba21-455f-afb3-c892a45f4f5f",
#     "href"=>
#      "http://localhost:3001/api/v2/studies/276329b5-ba21-455f-afb3-c892a45f4f5f",
#     "parent_uuid"=>"b715db56-7f28-4b74-89f4-b502cf5a1d45",
#     "created_at"=>"2015/01/08 18:18:16 +0000",
#     "updated_at"=>"2015/01/12 20:28:41 +0000"}]}
#
module IMedidataClient
  class StudiesRequest < Request
    def self.required_attributes
      [:user_uuid]
    end

    def initialize(attrs = {})
      raise argument_error unless self.class.required_attributes.all? {|p| attrs[p].present? }
      @user_uuid = attrs[:user_uuid]
    end

    def path
      "/api/v2/users/#{@user_uuid}/studies.json"
    end

    def http_method
      :get
    end 
  end
end
