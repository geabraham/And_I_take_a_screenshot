require 'imedidata/client'
require 'imedidata/requests/invitation_request'

class ImedidataUser
  include ActiveModel::Model
  include IMedidataClient
  attr_accessor :imedidata_user_uuid

  def initialize(attrs = {})
    unless attrs[:imedidata_user_uuid].present?
      raise ArgumentError.new("Please provide a uuid from a valid user in iMedidata.")
    end
    @imedidata_user_uuid = attrs[:imedidata_user_uuid]
  end

  # Checks if user has an invitation to study or study group as included in options as study_uuid or study_group_uuid.
  # Options should include a study or study group uuid key and value.
  #
  # If no invitation exists, an error is raised and rescued by #request_invitation! and added as an error on the user.
  #
  # Returns true if an invitation exists which has been accepted and which includes an
  #  app which has a uuid matching MAUTH_APP_UUID.
  # Returns false if one of these conditions is not met.
  #
  def has_study_invitation?(options = {})
    study_invitation = request_invitation!(options.merge(user_uuid: imedidata_user_uuid))
    study_invitation_includes_app?(study_invitation) && invitation_accepted?(study_invitation, options)
  rescue IMedidataClient::IMedidataClientError => e
    errors.add(:invitation, e.message)
    false
  end

  private

  def invitation_accepted?(study_invitation, options)
    unless study_invitation['accepted_at'].present?
      errors.add(:invitation, study_invitation_not_accepted_message(options))
      false
    else
      true
    end
  end

  def study_invitation_includes_app?(study_invitation)
    invitation_apps = study_invitation['apps'].presence
    unless !!invitation_apps && invitation_apps.any? { |aa| aa['uuid'] == MAUTH_APP_UUID }
      errors.add(:invitation, 'User invitation does not include app.')
      false
    else
      true
    end
  end

  def study_invitation_not_accepted_message(options)
    study_options = options.slice(:study_uuid, :study_group_uuid)
    "User invitation to #{study_options.keys.join(', ').gsub('_uuid', '')} with uuid #{study_options.values.join(', ')} has not been accepted."
  end
end
