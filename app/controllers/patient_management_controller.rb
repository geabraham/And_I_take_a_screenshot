require 'casclient'
require 'casclient/frameworks/rails/filter'

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "http://localhost:4567"
)

class PatientManagementController < ApplicationController
  layout 'patient_management'
  before_filter :authorize_user

  def select_site_and_study
  end

  private

  def authorize_user
    # ADD ME
    CASClient::Frameworks::Rails::Filter.filter(self)
    user_uuid = session[:cas_extra_attributes]['user_uuid']
    puts "Check user is authorized to be here. I.e. User headers or whatever are present and valid. " <<
      "If study and / or site uuid are present, this should be authorized too."
  end
end