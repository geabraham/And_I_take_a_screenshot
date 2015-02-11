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
      @available_subjects = (0..4).map {|idx| ["Subject-00#{idx}", "Subject-00#{idx}"]} #fetch_available_subjects_for_select
      @study_uuid, @study_site_name, @study_site_uuid = params[:study_uuid], @study_site['name'], @study_site['uuid']
      return render 'patient_management_grid'
    end
    @study_or_studies = studies_selection_list
  end

  def invite
    patient_enrollment_params = params.require(:patient_enrollment)
    country_and_language = JSON.parse(patient_enrollment_params.delete('country_language'))
    country_code, language_code = country_and_language['country_code'], country_and_language['language_code']
    patient_enrollment_params[:subject_id] = patient_enrollment_params.delete('subject')
    patient_enrollment_params.merge!(
      study_uuid: params[:study_uuid],
      study_site_uuid: params[:study_site_uuid],
      language_code: language_code,
      country_code: country_code,
      enrollment_type: 'in-person')
    headers = {http_headers: {'X-MWS-Impersonate' => params[:user_uuid]}}
    invitation_response = Euresource::PatientEnrollment.post!({patient_enrollment: patient_enrollment_params}, headers)
    if invitation_response.is_a?(Euresource::PatientEnrollment)
      render json: invitation_response, status: :created
    else
      render json: invitation_response, status: :unprocessable_entity
    end
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
    subjects_available_params = {study_uuid: params[:study_uuid], study_site_uuid: params[:study_site_uuid], available: true}
    Rails.logger.info_with_data("Requesting available subjects.", subjects_available_params: subjects_available_params)
    available_subjects = Euresource::Subject.get(:all, {params: subjects_available_params})
    Rails.logger.info_with_data("Received response for available subjects request.", available_subjects_response: available_subjects)
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
