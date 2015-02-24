require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class PatientManagementController < ApplicationController
  layout 'patient_management'
  include IMedidataClient
  include PatientInvitationFormHelper
  include PatientManagementPermissionsHelper
  before_filter :authorize_user
  before_filter :check_study_and_study_site_permissions!

  def select_study_and_site
    if @study_site
      @tou_dpn_agreements = fetch_tou_dpn_agreements_for_select
      @available_subjects = fetch_available_subjects_for_select
      @study_site_name, @study_site_uuid, @study_uuid = @study_site['name'], @study_site['uuid'], params[:study_uuid]
      return render 'patient_management_grid'
    end
    @study_or_studies = studies_selection_list
  end

  def invite
    patient_enrollment = invite_or_raise!
    render json: patient_enrollment, status: :created
  rescue StandardError => e
    message, status = available_subjects_error(e)
    Rails.logger.error_with_data("Rescuing error during patient invitation.", error: e.inspect)
    render json: message, status: status
  end

  def available_subjects
    params.require(:study_uuid) && params.require(:study_site_uuid)
    render json: fetch_available_subjects_for_select, status: :ok
  end

  # TODO: This should be render_error_page for disambiguation between this and plain text or json errors.
  #
  def render_error(exception = nil)
    render 'error', locals: {status_code: status_code}, status: status_code
  end

  private

  # Returns [message, status] corresponding to a 503 for connection error
  #  and defaulting to ['Subject not available. Please try again.', :not_found]
  #
  def available_subjects_error(error)
    # Faraday::Error::ConnectionFailed is raised when subjects service is down,
    # Euresource::ServerError is raised when iMedidata is down (subjects has to talk to iMedidata to authenticate the provider)
    #
    if error.is_a?(Faraday::Error::ConnectionFailed) || error.is_a?(Euresource::ServerError)
      [I18n.t('error.status_503.message'), :service_unavailable]
    else
      ['Subject not available. Please try again.', :not_found]
    end
  end

  # Return a patient enrollment or raise an error
  #
  def invite_or_raise!
    Rails.logger.info_with_data("Attempting to invite a new patient.", params: params)
    invitation_response = Euresource::PatientEnrollment.post!({
      patient_enrollment: clean_params_for_patient_enrollment(params)}, http_headers: impersonate_header)
    Rails.logger.info_with_data("Received response for patient invitation request.", invitation_response: invitation_response.inspect)
    raise Euresource::ResourceNotSaved.new() unless invitation_response.is_a?(Euresource::PatientEnrollment)
    invitation_response
  end

  # Request all TouDpnAgreements
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

  # Request available subjects for the current study and study site.
  # Returns available subjects for select or an empty array.
  #
  def fetch_available_subjects_for_select
    subjects_available_params = {study_uuid: params[:study_uuid], study_site_uuid: params[:study_site_uuid], available: true}
    Rails.logger.info_with_data("Requesting available subjects.", subjects_available_params: subjects_available_params)
    available_subjects = Euresource::Subject.get(:all, {params: subjects_available_params})
    Rails.logger.info_with_data("Received response for available subjects request.", available_subjects_response: available_subjects.inspect)
    subjects = attributes_or_empty_array(available_subjects, ['subject_identifier'])
    subjects.map {|s| [s['subject_identifier'], s['subject_identifier']]}
  rescue StandardError
    []
  end

  # Defend against unexpected response types
  #
  def attributes_or_empty_array(response, attributes)
    response.is_a?(Array) ? response.map {|s| s.attributes.slice(*attributes)} : []
  end

  def studies_selection_list
    @study ? [[@study['name'], @study['uuid']]] : name_uuid_options_array(@studies)
  end

  def tou_dpn_agreement_attributes
    ['language', 'language_code', 'country', 'country_code']
  end
end
