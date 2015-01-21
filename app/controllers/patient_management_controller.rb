require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class PatientManagementController < ApplicationController
  layout 'patient_management'
  include IMedidataClient
  before_filter :authorize_user

  def select_study_and_site
    # TODO: If both study uuid and study site uuid are present,
    #  redirect to the patient management grid.
    @study_or_studies = studies_selection_list
    @study_sites = study_sites_selection_list
    render 'select_study_and_site'
  end

  private

  def studies_selection_list
    if params[:study_uuid].present?
      study = request_study!(params)['study']
      [[study['name'], study['uuid']]]
    elsif
      studies = request_studies!(params)['studies']
      uniq_name_and_uuids(studies)
    end
  end

  def study_sites_selection_list
    if params[:study_uuid].present?
      study_sites = request_study_sites!(params)['study_sites']
      uniq_name_and_uuids(study_sites)
    else
      []
    end
  end
end
