require 'imedidata/request'
require 'imedidata/requests/app_assignments_request'
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

  def request_app_assignments!(options = {})
    request = AppAssignmentsRequest.new(user_uuid: options[:user_uuid], study_uuid: options[:study_uuid])

    app_assignments_response = request.response

    unless app_assignments_response.status == 200
      raise IMedidataClientError.new("App Assignments request failed for #{options[:user_uuid]}." <<
        "Response: #{app_assignments_response.status} #{app_assignments_response.body}")
    end

    JSON.parse(app_assignments_response.body)['apps']
  end

  class IMedidataClientError < StandardError; end
end
