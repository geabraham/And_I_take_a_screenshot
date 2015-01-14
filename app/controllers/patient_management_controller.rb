require 'casclient'
require 'casclient/frameworks/rails/filter'
require_relative '../models/imedidata_user'

class PatientManagementController < ApplicationController
  before_filter :authorize_user, :check_app_assignment

  def select_study_and_site
    @studies_or_sites = if (study_uuid = params[:study_uuid])
      imedidata_user.get_study_sites!(study_uuid)
    else
      imedidata_user.get_studies!
    end
    render json: @studies_or_sites, status: :ok
  end

  private

  def authorize_user
    unless CASClient::Frameworks::Rails::Filter.filter(self)
      redirect_to(CASClient::Frameworks::Rails::Filter.login_url(self)) and return
    end
  end

  def check_app_assignment
    # If the user is arriving from the apps pane, there will be a study_group_uuid parameter
    # If the user is arriving from the studies pane, there will be a study parameter
    # App assignment request requires the context of a study.
    #
    unless [:study_uuid, :study_group_uuid].any? { |k| params.include?(k) } && imedidata_user.check_study_invitation!(params)
      render json: {message: no_app_assigment_error_message}, status: 422
    end
  end

  def imedidata_user
    @imedidata_user ||= IMedidataUser.new(imedidata_user_uuid: current_user_uuid)
  end

  def current_user_uuid
    @current_user_uuid ||= current_user.present? ? current_user['user_uuid'] : nil
  end

  # Returns the uuid of the current session
  # {"user_id"=>"7", "user_uuid"=>"06acf77e-c2fe-4bcd-b44a-dd2fea8bd1a3", "user_email"=>"abarciauskas+3@mdsol.com"}
  def current_user
    @current_user ||= session[:cas_extra_attributes]
  end

  def no_app_assigment_error_message
    "You are not authorized for patient management. #{imedidata_user.errors.full_messages}"
  end
end
