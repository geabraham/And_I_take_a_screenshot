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
    unless CASClient::Frameworks::Rails::Filter.filter(self)
      redirect_to(CASClient::Frameworks::Rails::Filter.login_url(self))
    end
    @imedidata_user = IMedidataUser.new(imedidata_user_uuid: current_user_uuid)
  end

  def check_app_assignment
    # If the user is arriving from the apps pane, there will be a study_group_uuid parameter
    # If the user is arriving from the studies pane, there will be a study parameter
    # App assignment request requires the context of a study
    #
    @study_uuid = params[:study_uuid] || params[:study_group_uuid]

    unless @study_uuid.present? && @imedidata_user.is_assigned_to_app?(@study_uuid)
      render json: {message: no_app_assigment_error_message}, status: 422
    end
  end

  def current_user_uuid
    @current_user_uuid ||= current_user['user_uuid']
  end

  # Returns the uuid of the current session
  # {"user_id"=>"7", "user_uuid"=>"06acf77e-c2fe-4bcd-b44a-dd2fea8bd1a3", "user_email"=>"abarciauskas+3@mdsol.com"}
  def current_user
    @current_user ||= session[:cas_extra_attributes]
  end

  def no_app_assigment_error_message
    "You are not authorized for patient management."
  end
end
