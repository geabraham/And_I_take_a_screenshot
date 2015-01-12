require 'imedidata/request'
require 'imedidata/requests/invitation_request'
# Handles the business of sending requests to IMedidata API
#
module IMedidataClient

  # Returns an array of security questions
  #
  def request_security_questions!(options = {})
    request = SecurityQuestionsRequest.new(locale: options[:locale])
    security_questions_response = request.response

    unless security_questions_response.status == 200
      raise IMedidataClientError.new("Security Questions request failed for #{options[:locale]}. " <<
        "Response: #{security_questions_response.status} #{security_questions_response.body}")
    end

    JSON.parse(security_questions_response.body)['user_security_questions']
  end

  def request_invitation!(options = {})
    request = InvitationRequest.new(user_uuid: options[:user_uuid], study_uuid: options[:study_uuid])

    invitation_response = request.response

    unless invitation_response.status == 200
      raise IMedidataClientError.new("Invitation request failed for #{options[:user_uuid]}. " <<
        "Response: #{invitation_response.status} #{invitation_response.body}")
    end

    JSON.parse(invitation_response.body)
  end

  class IMedidataClientError < StandardError; end
end
