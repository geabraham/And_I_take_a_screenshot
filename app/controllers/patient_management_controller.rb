require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class PatientManagementController < ApplicationController
  layout 'patient_management'
  include IMedidataClient
  before_filter :authorize_user

  def select_study_and_site
    if @study_site = selected_and_authorized_study_site
      @tou_dpn_agreements = fetch_tou_dpn_agreements_for_select
      @available_subjects = fetch_available_subjects_for_select
      @study_site_name = @study_site['name']
      return render 'patient_management_grid'
    end
    @study_or_studies = studies_selection_list
  end

  def invite
    patient_enrollment_params = {'patient_enrollment' => params.require(:patient_enrollment)}
    headers = {'MCC-Impersonate' => params[:user_uuid]}
    invitation_response = Euresource::PatientEnrollment.post(patient_enrollment_params, headers)
  end

  def render_error(exception = nil)
    render 'error', locals: {status_code: status_code}, status: status_code
  end

  private

  def selected_and_authorized_study_site
    Rails.logger.info_with_data("Checking for selected and authorized study site.", params: params)
    if params[:study_uuid] && params[:study_site_uuid] && study_sites = request_study_sites!(params).presence
      study_sites['study_sites'].find {|ss| ss['uuid'] == params[:study_site_uuid]}
    else
      Rails.logger.info_with_data("Not all params or insufficient permissions for patient management.", params: params)
      nil
    end
  end

  # Review: Euresource, it appears, throws errors as opposed to error responses we can pass along.
  #  All are caught with application controller rescuing standard error which seems the best we can do.
  #
  def fetch_tou_dpn_agreements_for_select
    Rails.logger.info("Requesting TouDpnAgreements.")
    tou_dpn_agreements = Euresource::TouDpnAgreement.get(:all)
    Rails.logger.info_with_data("Received response for TouDpnAgreements request.", tou_dpn_agreements_response: tou_dpn_agreements.inspect)
    languages_and_countries = attributes_or_empty_array(tou_dpn_agreements, tou_dpn_agreement_attributes)
    languages_and_countries.map { |lc| ["#{lc['country']} / #{lc['language']}", lc.slice('language_code', 'country_code').to_json] }
  end

  def fetch_available_subjects_for_select
    available_subjects = Euresource::Subject.get(:all, {params: {
      study_uuid: params[:study_uuid],
      study_site_uuid: params[:study_site_uuid],
      available: true}})
    subjects = attributes_or_empty_array(available_subjects, ['subject_identifier'])
    subjects.map {|s| [s['subject_identifier'], s['subject_identifier']]}
  end

  # Defend against unexpected response types
  #
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
