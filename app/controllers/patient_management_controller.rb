require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class PatientManagementController < ApplicationController
  layout 'patient_management'
  include IMedidataClient
  before_filter :authorize_user

  def select_study_and_site
    @study_or_studies = studies_selection_list
    @study_sites = study_sites_selection_list
    render 'select_study_and_site'
  rescue IMedidataClient::IMedidataClientError => e
    render json: {errors: "You are not authorized for patient management. #{e.message}"}, status: :unauthorized
  end

  def sites
    render json: request_study_sites!(params)['study_sites'].uniq.collect{|ss| [ss['name'], ss['uuid']]}
  end

  private

  def authorize_user
    # Redirects to login page if there is no active session
    #
    if CASClient::Frameworks::Rails::Filter.filter(self)
      @user_email = session[:cas_extra_attributes]['user_email']
      params.merge!(user_uuid: session[:cas_extra_attributes]['user_uuid'])
    end
  end

  def studies_selection_list
    if params[:study_uuid].present?
      study = request_study!(study_uuid: params[:study_uuid])['study']
      [[study['name'], study['uuid']]]
    else
      studies = request_studies!(params)['studies']
      studies.uniq.collect {|s| [s['name'], s['uuid']] }
    end
  end

  def study_sites_selection_list
    if params[:study_uuid].present?
      study_sites = request_study_sites!(params)['study_sites']
      @study_sites = study_sites.uniq.collect{|ss| [ss['name'], ss['uuid']]}
    else
      []
    end
  end
end
