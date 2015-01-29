require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class PatientManagementController < ApplicationController
  layout 'patient_management'
  include IMedidataClient
  before_filter :authorize_user

  def select_study_and_site
    if params[:study_uuid] && params[:study_site_uuid]
      # TODO: Check study and site privilege here
      #
      @tou_dpn_agreements = fetch_tou_dpn_agreements
      @available_subjects = fetch_available_subjects
      return render 'patient_management_grid'
    end
    @study_or_studies = studies_selection_list
  end

  private

  def fetch_tou_dpn_agreements
    tou_dpn_agreements = Euresource::TouDpnAgreement.get(:all)
    attributes_or_empty_array(tou_dpn_agreements, tou_dpn_agreement_attributes)
  end

  def fetch_available_subjects
    available_subjects = Euresource::Subject.get(:all, {params: {
      study_uuid: params[:study_uuid],
      study_site_uuid: params[:study_site_uuid],
      available: true}})
    attributes_or_empty_array(available_subjects, ['subject_identifier'])
  end

  def attributes_or_empty_array(response, attributes)
    response.is_a?(Array) ? response.map {|s| s.attributes.slice(*attributes)} : []
  end

  def studies_selection_list
    if params[:study_uuid].present?
      study = request_study!(params)['study']
      [[study['name'], study['uuid']]]
    elsif
      studies = request_studies!(params)['studies']
      name_uuid_options_array(studies)
    end
  end

  def tou_dpn_agreement_attributes
    ['language', 'language_code', 'country', 'country_code']
  end
end
