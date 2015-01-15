require 'imedidata/request'

# Handles the business of sending requests to IMedidata API
#
module IMedidataClient

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
