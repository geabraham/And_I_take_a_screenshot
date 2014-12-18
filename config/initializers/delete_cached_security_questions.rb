# Clear cached security questions on startup, 
#   in case remote security questions have changed.
#
Rails.cache.delete_matched(/(.*)#{RemoteSecurityQuestions.key_for_locale('')}/)
