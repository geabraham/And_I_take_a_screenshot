
def get_table_column_index(selector, column_header)
  find(selector).all("th").each_with_index do |header, i|
     return i if column_header == header.text
  end
end

def study_or_site_object(object_name, object_type)
  object_type == 'studies' ? find_object_by_name(@studies, object_name) : find_object_by_name(@study_sites, object_name)
end

# Takes a array of hashes and returns the hash with the value 'object_name' for key 'name'
#
def find_object_by_name(array_of_hashes, object_name)
  array_of_hashes.find{|object| object['name'] == object_name}
end

def mock_invite_error_response_with(error)
  allow(Euresource::PatientEnrollment).to receive(:post!).with({patient_enrollment: {
    email: '',
    initials: '',
    country_code: @selected_country_language['country_code'],
    language_code: @selected_country_language['language_code'],
    enrollment_type: 'in-person',
    study_uuid: @current_site_object['study_uuid'],
    study_site_uuid: @current_site_object['uuid'],
    subject_id: @selected_mock_subject['subject_identifier']
  }.stringify_keys}, http_headers: {'X-MWS-Impersonate' => @user_uuid}).and_raise(error)
end
