class Medidation < Euresource::Medidation
  include ActiveModel::Validations

  validates_presence_of :first_name, :last_name

  # This method only useful when we fake medidation
  # service for testing. In the actual service call
  # this will override the method implemented
  # in Blueprint Service with the same content.
  def job_title_oid
    begin
      job_title_uuid.blank? ? '' : Euresource::JobTitle.get(job_title_uuid).oid
    rescue Euresource::ResourceNotFound, ArgumentError
      ''
    end
  end

end
