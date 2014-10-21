class HollywoodController < ApplicationController
  def index
  end

  def helpers
    @helpers_data = get_json_data('helpers')
  end
end
