# coding: utf-8
require 'yaml'


# Class handles writing and fetching security questions into cache.
# Currently, cache store is the default ActiveSupport::Cache::FileStore.
# TODO: Use memcached or some other superior cache store.
#   Story: https://jira.mdsol.com/browse/MCC-140278
#   While it is not likely this will eat much disk space, it is not a robust solution.
#
# SecurityQuestions.find('jpn')
# => [{"name"=>"您在哪一年出生？", "id"=>"1"},
#     {"name"=>"你的社会安全号码(SSN)或报税号码的最后四位数是什么?", "id"=>"2"},
#     {"name"=>"您父亲的中间名是什么？", "id"=>"3"},
#     {"name"=>"您的第一所学校的名称是什么？", "id"=>"4"}, ...]
# There are 11 questions as of Dec 2014. For a complete list see the bottom of this file.
#
# The only supported locales for security questions are jpn, chi and kor;
#  everything else defaults to eng.
#
class SecurityQuestions
  class << self
    include IMedidataClient

    # Returns security questions
    #
    def find(locale)
      res = SecurityQuestionsData::SECURITY_QUESTIONS[locale]
      if res.nil?
        raise StandardError.new "Locale not found: " + locale
      else
        res
      end
    end

  end
end
#
# Security Questions as of Dec 2014:
#
# [{"name"=>"What year were you born?", "id"=>"1"},
#  {"name"=>"Last four digits of SSN or Tax ID number?", "id"=>"2"},
#  {"name"=>"What is your father's middle name?", "id"=>"3"},
#  {"name"=>"What was the name of your first school?", "id"=>"4"},
#  {"name"=>"Who was your childhood hero?", "id"=>"5"},
#  {"name"=>"What is your favorite pastime?", "id"=>"6"},
#  {"name"=>"What is your all-time favorite sports team?", "id"=>"7"},
#  {"name"=>"What was your high school team or mascot?", "id"=>"8"},
#  {"name"=>"What make was your first car or bike?", "id"=>"9"},
#  {"name"=>"What is your pets name?", "id"=>"10"},
#  {"name"=>"What is your mother's middle name?", "id"=>"11"}]
