# ir = IMedidataClient::InvitationRequest.new({
#   user_uuid: '06acf77e-c2fe-4bcd-b44a-dd2fea8bd1a3',
#   study_uuid: 'b715db56-7f28-4b74-89f4-b502cf5a1d45'})
# 
# JSON.parse(ir.response.body)
#
# {"inviter"=>{"uuid"=>"06acf77e-c2fe-4bcd-b44a-dd2fea8bd1a3"},
#  "apps"=>[{"uuid"=>"ddd9a496-0a1c-48bf-925e-496ee64ddf48"}],
#  "as_owner"=>nil,
#  "site_personnel"=>false,
#  "all_sites"=>false,
#  "owns_all_sites"=>false,
#  "accepted_at"=>"2015/01/09 23:43:19 +0000"}
#
module IMedidataClient
  class InvitationRequest < Request
    def self.required_attributes
      [:user_uuid]
    end

    def additional_required_attributes
      [:study_uuid, :study_group_uuid]
    end
    def initialize(attrs = {})
      raise argument_error unless self.class.required_attributes.all? {|p| attrs[p].present? }
      raise argument_error(additional_required_attributes) unless additional_required_attributes.any? {|p| attrs[p].present? }
      @user_uuid, @study_uuid, @study_group_uuid = attrs[:user_uuid], attrs[:study_uuid], attrs[:study_group_uuid]
    end

    def path
      if @study_uuid.present?
        "/api/v2/studies/#{@study_uuid}/users/#{@user_uuid}/invitation.json"
      elsif @study_group_uuid.present?
        "/api/v2/study_groups/#{@study_group_uuid}/users/#{@user_uuid}/invitation.json"
      end 
    end

    def http_method
      :get
    end 
  end
end
