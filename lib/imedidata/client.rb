require 'imedidata/request'
load 'lib/imedidata/requests/security_questions_request.rb'
require 'imedidata/requests/invitation_request'

# Handles the business of sending requests to IMedidata API
#
module IMedidataClient

  ['security_questions', 'invitation', 'studies', 'study_sites'].each do |request_type|
    define_method("request_#{request_type}!") do |options|
      request = "IMedidataClient::#{"#{request_type}_request".titleize.gsub(' ','')}".constantize.new(options)
      response = request.response

      unless response.status == request.expected_response_status
        raise IMedidataClientError.new("#{request_type.titleize} request failed for #{options}. " <<
          "Response: #{response.status} #{response.body}")
      end

      JSON.parse(response.body)
    end
  end

  class IMedidataClientError < StandardError; end
end
