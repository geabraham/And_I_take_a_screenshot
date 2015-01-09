require 'imedidata/request'

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

  class IMedidataClientError < StandardError; end
end
