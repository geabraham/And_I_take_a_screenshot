class PatientManagementController < ApplicationController
  before_filter :authorize_user

  def select_site_and_study
  end

  private

  def authorize_user
    # ADD ME
    puts "Check user is authorized to be here. I.e. User headers or whatever are present and valid. " <<
      "If study and / or site uuid are present, this should be authorized too."
  end
end