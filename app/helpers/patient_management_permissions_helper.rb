module PatientManagementPermissionsHelper
  include IMedidataClient

  # Checks for existence of study and study site parameters and authorizes user for those identifiers if they are present.
  # If permissions check out, assigns appropriate instance variables (studies, study and study_site).
  #  If no permissions exist, an error is raised via the IMedidataClient.
  #  If response from iMedidata does not include the expected study or study site, an error is raised.
  #
  def check_study_and_study_site_permissions!
    params[:study_site_uuid] && params[:study_uuid] ? check_study_site_permissions : check_study_permissions
  end

  private

  def check_study_site_permissions
    Rails.logger.info_with_data("Checking study site authorizations for patient management.", params: params)
    study_sites = request_study_sites!(params)
    raise_and_log(:study_site) unless study_sites.present?
    @study_site = study_sites['study_sites'].find { |ss| ss['uuid'] == params[:study_site_uuid]}
    true
  end

  def check_study_permissions
    Rails.logger.info_with_data("Checking study authorizations for patient management.", params: params)
    @studies = request_studies!(params)['studies']
    if params[:study_uuid]
      @study = @studies.find {|s| s['uuid'] == params[:study_uuid]}
      raise_and_log(:study) unless @study.present?
    end
    true
  end

  def raise_and_log(object_type)
    error_message = no_permissions_error(object_type, object_type == :study_site ? params[:study_site_uuid] : params[:study_uuid])
    Rails.logger.error_with_data(error_message, params: params)
    raise PermissionsError.new(error_message)
  end

  def no_permissions_error(object_type, object_uuid)
    "No patient management permissions for user #{params[:user_uuid]} for #{object_type} #{object_uuid}"
  end

  class PermissionsError < StandardError; end
end
