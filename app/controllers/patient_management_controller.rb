require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class PatientManagementController < ApplicationController
  include IMedidataClient
  before_filter :authorize_user, :check_app_assignment

  def select_study_and_site
    @studies_or_sites = !!(study_uuid = params[:study_uuid]) ? request_study_sites!(params) : request_studies!(params)
    render json: @studies_or_sites, status: :ok
  end

  private

  def authorize_user
    unless CASClient::Frameworks::Rails::Filter.filter(self)
      redirect_to(CASClient::Frameworks::Rails::Filter.login_url(self)) and return
    end
  end

  # Returns 422 if there are no study or study group params 
  #   or user has no invitation to the study or study group.
  # 
  # If the user is arriving from the apps pane, there will be a study_group_uuid parameter
  # If the user is arriving from the studies pane, there will be a study parameter
  # App assignment request requires the context of a study.
  #
  def check_app_assignment
    unless some_study_params? && imedidata_user.has_study_invitation?(params)
      render json: {message: no_app_assigment_error_message}, status: 422
    else
      params.merge!(user_uuid: imedidata_user.imedidata_user_uuid)
    end
  end

  def imedidata_user
    # session[:cas_session_attributes]
    # {"user_id"=>"7", "user_uuid"=>"06acf77e-c2fe-4bcd-b44a-dd2fea8bd1a3", "user_email"=>"abarciauskas+3@mdsol.com"}
    @imedidata_user ||= if (current_user = session[:cas_extra_attributes].presence)
      current_user.present? ? IMedidataUser.new(imedidata_user_uuid: current_user['user_uuid']) : nil
    end
  end

  def some_study_params?
    [:study_uuid, :study_group_uuid].any? { |k| params.include?(k) }
  end

  def no_app_assigment_error_message
    "You are not authorized for patient management. #{imedidata_user.errors.full_messages}"
  end
end
