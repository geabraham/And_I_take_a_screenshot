mauth_yaml_file = File.join(Rails.root, 'config/mauth.yml')
if File.exist?(mauth_yaml_file)
  config = Rails.application.config
  mauth_conf = YAML.load_file(mauth_yaml_file)[Rails.env]
  require 'mauth/rack'
  # ResponseSigner OPTIONAL; only use if you are registered in mauth service
  # config.middleware.use MAuth::Rack::ResponseSigner, mauth_conf
  # if Rails.env.test?
  #   require 'mauth/fake/rack'
  #   config.middleware.use MAuth::Rack::RequestAuthenticationFaker, mauth_conf
  # else
  #   config.middleware.use MAuth::Rack::RequestAuthenticatorNoAppStatus, mauth_conf
  # end

  MAUTH_CLIENT = MAuth::Client.new(mauth_conf)
elsif Rails.env.production?
  raise IOError.new("mauth-client must be enabled and configured in production")
end