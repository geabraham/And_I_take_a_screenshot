module PatientManagementPermissionsHelper
  include IMedidataClient

  def check_study_and_study_site_permissions!
    if params[:study_site_uuid]
      study_sites = request_study_sites!(params)
      @study_site = study_sites['study_sites'].find { |ss| ss['uuid'] == params[:study_site_uuid]}
      true
    else
      studies = request_studies!(params)
      @studies = studies['studies']
      if params[:study_uuid]
        @study = @studies.find {|s| s['uuid'] == params[:study_uuid]}
        raise no_study_permissions_error unless @study.present?
      end
      true
    end
  end

  private
  def params
    params ||= {}
  end

  def no_study_permissions_error
    PatientManagementPermissionsError.new("No study permissions for user #{params[:user_uuid]} for study #{params[:study_uuid]}")
  end

  class PatientManagementPermissionsError < StandardError; end
end
