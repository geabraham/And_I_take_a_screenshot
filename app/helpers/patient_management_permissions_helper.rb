module PatientManagementPermissionsHelper
  include IMedidataClient

  # Checks for existence of study and study site parameters and authorizes user for the study or study site if they are present.
  # Assigns studies, study and study_site and returns true if permissions exist.
  #  Otherwise raises an error via iMedidataClient or Permissions Error.
  #
  def check_study_and_study_site_permissions!
    params[:study_site_uuid] ? check_study_site_permissions : check_study_permissions
  end

  private

  def check_study_site_permissions
    Rails.logger.info_with_data("Checking for selected and authorized study site.", params: params)
    study_sites = request_study_sites!(params)
    unless study_sites.present?
      Rails.logger.error_with_data("Not all params or insufficient permissions for patient management.", params: params)
      raise no_permissions_error('study_site', params[:study_site_uuid])
    end
    @study_site = study_sites['study_sites'].find { |ss| ss['uuid'] == params[:study_site_uuid]}
    true
  end

  def check_study_permissions
    @studies = request_studies!(params)['studies']
    if params[:study_uuid]
      @study = @studies.find {|s| s['uuid'] == params[:study_uuid]}
      raise no_permissions_error('study', params[:study_uuid]) unless @study.present?
    end
    true
  end

  def no_permissions_error(object_type, object_uuid)
    PermissionsError.new("No study permissions for user #{params[:user_uuid]} for #{object_type} #{object_uuid}")
  end

  class PermissionsError < StandardError; end
end
