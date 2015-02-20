module PatientManagementPermissionsHelper
  include IMedidataClient

  def check_study_and_study_site_permissions!
    if params[:study_site_uuid]
      check_study_site_permissions
    else
      check_study_permissions
    end
  end

  private

  def check_study_site_permissions
    study_sites = request_study_sites!(params)['study_sites']
    @study_site = study_sites.find { |ss| ss['uuid'] == params[:study_site_uuid]}
    true
  end

  def check_study_permissions
    @studies = request_studies!(params)['studies']
    if params[:study_uuid]
      @study = @studies.find {|s| s['uuid'] == params[:study_uuid]}
      raise no_study_permissions_error unless @study.present?
    end
    true
  end

  def params
    params ||= {}
  end

  def no_study_permissions_error
    PermissionsError.new("No study permissions for user #{params[:user_uuid]} for study #{params[:study_uuid]}")
  end

  class PermissionsError < StandardError; end
end
