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
      study_options = options.slice(:study_uuid, :study_group_uuid)
      errors.add(
        :invitation,
        "User has no accepted invitation to #{study_options.keys.join(', ').gsub('_uuid', '')} with uuid #{study_options.values.join(', ')}.")
      false
    else
      true
    end
  end

  def get_studies!
    request_studies!(user_uuid: imedidata_user_uuid)
  end

  def get_study_sites!(study_uuid)
    request_study_sites!(user_uuid: imedidata_user_uuid, study_uuid: study_uuid)
  end
end
