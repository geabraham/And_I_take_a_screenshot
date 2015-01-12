mauth_yaml_file = File.join(Rails.root, 'config/mauth.yml')

if File.exist?(mauth_yaml_file)
  mauth_conf = YAML.load_file(mauth_yaml_file)[Rails.env]
  # TODO: Raise if none is provided.
  #
  MAUTH_APP_UUID = mauth_conf['app_uuid']
  MAUTH_CLIENT = MAuth::Client.new(mauth_conf)
elsif Rails.env.production?
  raise IOError.new("mauth-client must be enabled and configured in production")
end
