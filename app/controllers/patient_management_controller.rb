require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class PatientManagementController < ApplicationController
  include IMedidataClient
  before_filter :authorize_user

  def select_study_and_site
    @studies_or_sites = params[:study_uuid].present? ? request_study_sites!(params) : request_studies!(params)
    render json: @studies_or_sites, status: :ok
  rescue IMedidataClient::IMedidataClientError => e
    render json: {errors: "You are not authorized for patient management. #{e.message}"}, status: :unauthorized
  end

  private

  def authorize_user
    # Redirects to login page if there is no active session
    #
    if CASClient::Frameworks::Rails::Filter.filter(self)
      params.merge!(user_uuid: session[:cas_extra_attributes]['user_uuid'])
    end
  end
end
