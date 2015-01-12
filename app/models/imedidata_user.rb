require 'imedidata/client'
require 'imedidata/requests/app_assignments_request'

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

  def is_assigned_to_app?(study_uuid)
    # TODO: allow raise or rescue here? Otherwise this method raises.
    #
    assigned_apps = request_app_assignments!(user_uuid: imedidata_user_uuid, study_uuid: study_uuid)

    unless assigned_apps.any? { |aa| aa['uuid'] == MAUTH_APP_UUID }
      errors.add(:app_assignments, 'IMedidata User is not assigned to the app.')
      false
    else
      true
    end
  end
end
