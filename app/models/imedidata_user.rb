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
    study_object_uuid_symbol = "#{study_object(options)}_uuid".to_sym
    study_object_uuid = options[study_object_uuid_symbol]

    # TODO: allow raise or rescue here? Otherwise this method raises.
    #
    invitation = request_invitation!(user_uuid: imedidata_user_uuid, study_object_uuid_symbol => study_object_uuid)
    invitation_apps = invitation['apps'].presence

    unless invitation_apps.any? { |aa| aa['uuid'] == MAUTH_APP_UUID } && invitation['accepted_at'].present?
      errors.add(:invitation, "User has no accepted invitation to #{study_object} #{study_object_uuid}")
      false
    else
      true
    end
  end

  private

  def study_object(options = {})
    @study_object ||= if options[:study_uuid].present?
      'study'
    elsif options[:study_group_uuid].present?
      'study_group'
    else
      raise ArgumentError.new('No study or study group uuid provided.')
    end
  end
end
