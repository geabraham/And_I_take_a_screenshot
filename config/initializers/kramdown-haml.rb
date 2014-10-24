module Haml::Filters::Kramdown
  include Haml::Filters::Base

  def render(text)
    Kramdown::Document.new(text, {
      coderay_line_numbers: nil
    }).to_html
  end
end
