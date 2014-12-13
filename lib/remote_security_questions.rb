require 'imedidata_client'
require 'json'
require 'pry'
class RemoteSecurityQuestions
  class << self
    include IMedidataClient
    def find_or_fetch(locale)
      if !!(security_questions = Kernel.const_get(constant_name_as_string(locale)) rescue nil)
        security_questions
      else
        fetch(locale)
      end
    end

    def fetch(locale)
      response = request_security_questions!(locale: locale)
      Kernel.const_set(constant_name_as_string(locale), response)
    end

    private
    def constant_name_as_string(locale)
      "#{locale.upcase}_SECURITY_QUESTIONS"
    end
  end
end