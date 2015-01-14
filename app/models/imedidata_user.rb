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

  # Options should include a study or study group uuid key and value.
  # Checks if user has an invitation to study or study group as included in options as study_uuid or study_group_uuid.
  # If no invitation exists, an error is raised by #request_invitation!
  # If an invitation exists and both the conditions that MAUTH_APP_UUID is included in the list of apps for that study or study group
  #   and the invitation is accepted
  # Raises an error if an invitation exists for study or study group with an app which includes minotaur's MAUTH_APP_UUID
  #
  def check_study_invitation!(options = {})
    study_invitation = request_invitation!(options.merge(user_uuid: imedidata_user_uuid))
    study_invitation_includes_app?(study_invitation) && invitation_accepted?(study_invitation, options)
  end

  private

  def invitation_accepted?(study_invitation, options)
    unless study_invitation['accepted_at'].present?
      errors.add(:invitation, no_study_invitation_message(options))
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

  def no_study_invitation_message(options)
    study_options = options.slice(:study_uuid, :study_group_uuid)
    "User invitation to #{study_options.keys.join(', ').gsub('_uuid', '')} with uuid #{study_options.values.join(', ')} has not been accepted."
  end
end
