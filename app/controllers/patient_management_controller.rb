require 'casclient'
require 'casclient/frameworks/rails/filter'
load 'app/models/imedidata_user.rb'

CAS_BASE_URL = 'http://localhost:4567'
CASClient::Frameworks::Rails::Filter.configure(cas_base_url: CAS_BASE_URL)

class PatientManagementController < ApplicationController
  before_filter :authorize_user, :check_app_assignment

  def select_study_and_site
  end

  private

  def authorize_user
    CASClient::Frameworks::Rails::Filter.filter(self)
    # {"user_id"=>"7", "user_uuid"=>"06acf77e-c2fe-4bcd-b44a-dd2fea8bd1a3", "user_email"=>"abarciauskas+3@mdsol.com"}
    @user_uuid = if cas_session = session[:cas_extra_attributes]
      cas_session['user_uuid']
    end
    @current_user = IMedidataUser.new(imedidata_user_uuid: @user_uuid)
  end

  def check_app_assignment
    # If the user is arriving from the apps pane, there will be a study_group_uuid parameter
    # If the user is arriving from the studies pane, there will be a study parameter
    # App assignment request requires the context of a study
    #
    @study_uuid = params[:study_uuid] || params[:study_group_uuid]

    unless @study_uuid.present? && @current_user.is_assigned_to_app?(@study_uuid)
      return render json: {message: no_app_assigment_error_message}, status: 422
    end
  end

  def no_app_assigment_error_message
    "You are not authorized for patient management."
  end
end
