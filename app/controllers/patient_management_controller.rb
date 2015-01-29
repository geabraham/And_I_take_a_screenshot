require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class PatientManagementController < ApplicationController
  layout 'patient_management'
  include IMedidataClient
  before_filter :authorize_user

  def select_study_and_site
    if params[:study_uuid] && params[:study_site_uuid]
      # REVIEW: Check study and site privilege here or rely on subjects to do so?
      #
      @tou_dpn_agreements = Euresource::TouDpnAgreement.get(:all).map do |agreement|
        agreement.attributes.slice(*tou_dpn_agreement_attributes)
      end

      return render 'patient_management_grid'
    end
    @study_or_studies = studies_selection_list
  end

  private

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
