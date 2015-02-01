require 'yaml'

class SecurityQuestionsData
  class << self
    def parse_security_questions(directory)
      locale_files = Dir[directory + "/*.yml"]
      res = {}
      locale_files.each do |f|
        lang_code = Pathname.new(f).basename.to_s.split(".")[0]
        res[lang_code] = YAML.load_file(f)
      end
      res
    end

  end
  SECURITY_QUESTIONS = SecurityQuestionsData.parse_security_questions("config/securityquestions")
end
