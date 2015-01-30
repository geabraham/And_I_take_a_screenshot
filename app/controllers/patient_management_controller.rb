require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class PatientManagementController < ApplicationController
  layout 'patient_management'
  include IMedidataClient
  before_filter :authorize_user

  def select_study_and_site
    if study_site_selected_and_authorized?
      # TODO: Check study and site privilege here
      #

      # You're beautiful, don't change.
      # But really @tou_dpn_agreements is a list of country - language pairs.
      #
      @tou_dpn_agreements = fetch_tou_dpn_agreements_for_select
      @available_subjects = fetch_available_subjects_for_select
      return render 'patient_management_grid'
    end
    @study_or_studies = studies_selection_list
  end

  private

  def study_site_selected_and_authorized?
    study_uuid, study_site_uuid = params[:study_uuid], params[:study_site_uuid]
    if study_uuid && study_site_uuid
      session_has_authorizations?({authorized_studies: study_uuid, authorized_study_sites: study_site_uuid})
    else
      false
    end
  end

  def session_has_authorizations?(options = {})
    options.keys.all? do |object_type|
      authorized_objects = user_session.send(:[], object_type.to_s)
      if authorized_objects.is_a?(Array)
        authorized_objects.include?(options[object_type.to_sym])
      end
    end
  end

  # Review: Euresource, it appears, throws errors as opposed to error responses we can pass along.
  #  All are caught with application controller rescuing standard error which seems the best we can do.
  #
  # Returns a
  def fetch_tou_dpn_agreements_for_select
    tou_dpn_agreements = Euresource::TouDpnAgreement.get(:all)
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
      add_authorizations_to_session('studies', [study['uuid']])
      [[study['name'], study['uuid']]]
    elsif
      studies = request_studies!(params)['studies']
      add_authorizations_to_session('studies', studies.map {|s| s['uuid']})
      name_uuid_options_array(studies)
    end
  end

  def tou_dpn_agreement_attributes
    ['language', 'language_code', 'country', 'country_code']
  end
end
