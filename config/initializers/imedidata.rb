require 'yaml'
 
imed_yaml_file = File.join(Rails.root, 'config/imedidata.yml')
if File.exist?(imed_yaml_file)
  imed_conf = YAML.load_file(imed_yaml_file)[Rails.env]
  IMED_BASE_URL = imed_conf['imedidata_base_url']
elsif Rails.env.production?
  raise IOError.new('imedidata base url configured in production')
end
