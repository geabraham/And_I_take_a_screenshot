require 'eureka_tools'
# This initializer uses eureka tools to fill our fake resources with
# fake data.  These resources were set up in config/initializers/eresource.rb.dice.
# This type of fakery can be useful during testing, if you are creating a service
# before all the backing services it will eventually integrate with exist.  All you need is an
# api document for the proposed service, and Eureka Tools can fake it for you.

# TODO: remove mocking in production

# I'm not sure exactly what this is
# for, except that maybe it is supposed to serve as an example of how
# to do this sort of thing.  It seems that we don't have job_title
# anymore in our api docs so this complains.  Commenting out for now
# unless everyone agrees it should be removed entirely.
#if Rails.env.development? || Rails.env.production?
#  [
#      {oid: "PRESIDENT", uuid: "8e19b514-5fa6-11e2-bcfd-0800200c9a66"},
#      {oid: "SOFTWARE_ENGINEER", uuid: "8e19b515-5fa6-11e2-bcfd-0800200c9a66"},
#      {oid: "VICE_PRESIDENT", uuid: "8e19b516-5fa6-11e2-bcfd-0800200c9a66"}
#  ].each do |job_title_attrs|
#    Euresource::JobTitle.post(job_title_attrs)
#  end
#  [
#      {first_name: "John", last_name: "Smith", uuid: "1e19b515-5fa6-11e2-bcfd-0800200c9a69", job_title_uuid: "8e19b514-5fa6-11e2-bcfd-0800200c9a66"},
#      {first_name: "James", last_name: "Jones", uuid: "2e19b515-5fa6-11e2-bcfd-0800200c9a69", job_title_uuid: "8e19b516-5fa6-11e2-bcfd-0800200c9a66"},
#      {first_name: "John", last_name: "Chaplin", uuid: "3e19b515-5fa6-11e2-bcfd-0800200c9a69", job_title_uuid: "8e19b516-5fa6-11e2-bcfd-0800200c9a66"},
#      {first_name: "John", last_name: "Doe", uuid: "4e19b515-5fa6-11e2-bcfd-0800200c9a69", job_title_uuid: "8e19b514-5fa6-11e2-bcfd-0800200c9a66"},
#      {first_name: "Tony", last_name: "Smith", uuid: "5e19b515-5fa6-11e2-bcfd-0800200c9a69", job_title_uuid: "8e19b515-5fa6-11e2-bcfd-0800200c9a66"}
#  ].each do |medidation_attrs|
#    Euresource::Medidation.post(medidation_attrs)
#  end
#end
