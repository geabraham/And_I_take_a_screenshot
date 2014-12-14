mauth_yaml_file = File.join(Rails.root, 'config/mauth.yml')

if File.exist?(mauth_yaml_file)
  config = Rails.application.config
  mauth_conf = YAML.load_file(mauth_yaml_file)[Rails.env]
  MAUTH_CLIENT = MAuth::Client.new(mauth_conf)
elsif Rails.env.production?
  raise IOError.new("mauth-client must be enabled and configured in production")
end
