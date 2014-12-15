require 'imedidata_client'
require 'json'

# Class handles writing and fetching security questions into cache.
# Currently, Rails cache is the default ActiveSupport::Cache::FileStore
# TODO: Use another cache store. While it is not likely this will use much disk space,
#   if anything goes awry it could eat up disk space on an app server.
#
# RemoteSecurityQuestions.find_or_fetch('jpn')
# => [{"name"=>"您在哪一年出生？", "id"=>"1"}, 
#     {"name"=>"你的社会安全号码(SSN)或报税号码的最后四位数是什么?", "id"=>"2"}, 
#     {"name"=>"您父亲的中间名是什么？", "id"=>"3"}, 
#     {"name"=>"您的第一所学校的名称是什么？", "id"=>"4"}, ...]
# There are 11 questions as of Dec 2014. For a complete list see the bottom of this file.
#
# The only supported locales for security questions are jpn, chi and kor;
#  everything else defaults to eng.
#
class RemoteSecurityQuestions
  class << self
    include IMedidataClient

    # Returns cached security questions or fetches them from remote location
    #
    def find_or_fetch(locale)
      if !!(security_questions = cache_fetch(locale) rescue nil)
        security_questions
      else
        remote_fetch(locale)
      end
    end

    # Makes a request to the iMedidata API for the questions in the locale provided
    #
    def remote_fetch(locale)
      response = request_security_questions!(locale: locale)
      cache_write(locale, response)
      response
    end

    def key_for_locale(locale)
      "#{locale}_security_questions"
    end

    private
    def cache_fetch(locale)
      Rails.cache.fetch(key_for_locale(locale))
    end

    def cache_write(locale, value)
      Rails.cache.write(key_for_locale(locale), value)
    end
  end
end
#
# [{"name"=>"What year were you born?", "id"=>"1"},
# {"name"=>"Last four digits of SSN or Tax ID number?", "id"=>"2"},
# {"name"=>"What is your father's middle name?", "id"=>"3"},
# {"name"=>"What was the name of your first school?", "id"=>"4"},
# {"name"=>"Who was your childhood hero?", "id"=>"5"},
# {"name"=>"What is your favorite pastime?", "id"=>"6"},
# {"name"=>"What is your all-time favorite sports team?", "id"=>"7"},
# {"name"=>"What was your high school team or mascot?", "id"=>"8"},
# {"name"=>"What make was your first car or bike?", "id"=>"9"},
# {"name"=>"What is your pets name?", "id"=>"10"},
# {"name"=>"What is your mother's middle name?", "id"=>"11"}]
