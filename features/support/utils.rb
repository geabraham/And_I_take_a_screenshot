
def get_table_column_index(selector, column_header)
  find(selector).all("th").each_with_index do |header, i|
     return i if column_header == header.text
  end
end


