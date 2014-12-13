require 'imedidata_client_request'

# Handles the business of sending requests to IMedidata API
#
module IMedidataClient

  # Returns hash of security questions
  #
  def request_security_questions!(options = {})
    unless SecurityQuestionsRequest.required_attributes.all? {|p| options.include?(p) }
      raise ArgumentError.new("Invalid arguments. Please provide #{SecurityQuestionsRequest.required_attributes.join(', ')}.")
    end
    security_questions_response = SecurityQuestionsRequest.new(locale: options[:locale]).response

    unless security_questions_response.status == 200
      raise IMedidataClientError.new("Security Questions request failed for #{options[:locale]}. " <<
        "Response: #{security_questions_response.status} #{security_questions_response.body}")
    end

    JSON.parse(security_questions_response.body)
  end

  class IMedidataClientError < StandardError; end
end