require 'imedidata/request'

# Handles the business of sending requests to IMedidata API
#
module IMedidataClient


  # Defines methods for each request type which returns the parsed response body.
  # E.g.: request_security_questions!(options)
  #  If the response status is the expected response status (200), returns the parsed security questions response.
  #  If the response status is not the expected response status, raises an IMedidataClient error with an informative message.
  #
  ['security_questions', 'studies', 'study_sites'].each do |request_type|
    define_method("request_#{request_type}!") do |options|
      request = "IMedidataClient::#{"#{request_type}_request".titleize.gsub(' ','')}".constantize.new(options)
      response = request.response

      unless response.status == request.expected_response_status
        raise imedidata_client_error(request_type, options, response)
      end

      JSON.parse(response.body)
    end
  end

  def imedidata_client_error(request_type, options, response)
    IMedidataClientError.new("#{request_type.titleize} request failed for #{options}. Response: #{response.status} #{response.body}")
  end

  class IMedidataClientError < StandardError; end
end
