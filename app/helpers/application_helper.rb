module ApplicationHelper
  def fetch_job_titles
    @job_titles.map { |job_title| [ job_title.oid, job_title.uuid ] }
  end
end
