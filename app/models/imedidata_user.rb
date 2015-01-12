require 'imedidata/client'
require 'imedidata/requests/invitation_request'

class IMedidataUser
  include ActiveModel::Model
  include IMedidataClient
  attr_accessor :imedidata_user_uuid

  def initialize(attrs = {})
    unless attrs[:imedidata_user_uuid].present?
      raise ArgumentError.new("Please provide a uuid from a valid user in iMedidata.")
    end
    @imedidata_user_uuid = attrs[:imedidata_user_uuid]
  end

  def has_accepted_invitation?(options = {})
    # TODO: allow raise or rescue here? Otherwise this method raises.
    #
    invitation = request_invitation!(options.merge(user_uuid: imedidata_user_uuid))
    invitation_apps = invitation['apps'].presence

    unless invitation_apps.any? { |aa| aa['uuid'] == MAUTH_APP_UUID } && invitation['accepted_at'].present?
      errors.add(
        :invitation,
        "User has no accepted invitation to study or study group with uuid #{options[:study_uuid].presence || options[:study_group_uuid].presence}")
      false
    else
      true
    end
  end
end
