
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
