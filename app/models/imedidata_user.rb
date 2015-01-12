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

  def has_invitation?(options = {})
    study_object = if options[:study_uuid].present?
      'study'
    elsif options[:study_group_uuid].present?
      'study_group'
    else
      raise ArgumentError.new('No study or study group uuid provided.')
    end
    study_object_uuid_symbol = "#{study_object}_uuid".to_sym
    study_object_uuid = options[study_object_uuid_symbol]

    # TODO: allow raise or rescue here? Otherwise this method raises.
    #
    assigned_apps = request_invitation!(user_uuid: imedidata_user_uuid, study_object_uuid_symbol => study_object_uuid)

    unless assigned_apps.any? { |aa| aa['uuid'] == MAUTH_APP_UUID }
      errors.add(:invitation, "User has no invitation to #{study_object} #{study_object_uuid}")
      false
    else
      true
    end
  end
end
