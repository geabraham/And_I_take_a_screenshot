# rr = IMedidataClient::RolesRequest.new({
#   user_uuid: '06acf77e-c2fe-4bcd-b44a-dd2fea8bd1a3',
#   study_uuid: '276329b5-ba21-455f-afb3-c892a45f4f5f',
#   app_uuid: 'ddd9a496-0a1c-48bf-925e-496ee64ddf48'})
# 
# JSON.parse(rr.response.body)
# {"roles"=>
#   [{"name"=>"Provider",
#     "oid"=>"com:mdsol:roles:123",
#     "uuid"=>"d4d041ec-d5f3-4921-b622-bf628f0ad3eb",
#     "study"=>false,
#     "site"=>false,
#     "href"=>"coming soon"}]}
class IMedidataClient::RolesRequest < IMedidataClient::Request
  def self.required_attributes
    [:user_uuid, :study_uuid]
  end

  def initialize(attrs = {})
    raise argument_error unless self.class.required_attributes.all? {|p| attrs[p].present? }
    @user_uuid, @study_uuid = attrs[:user_uuid], attrs[:study_uuid]
    @app_uuid = MAUTH_CLIENT.instance_variable_get("@config")['app_uuid']
  end

  def path
    "/api/v2/users/#{@user_uuid}/studies/#{@study_uuid}/apps/#{@app_uuid}/roles.json"
  end

  def http_method
    :get
  end
end
