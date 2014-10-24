class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html

  before_filter :set_locale

  protected
  # Set user's locale from request, assuming it comes from Checkmate.
  #TODO in future locale may be in header instead of params, depending on Checkmate
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def get_json_data(key = nil)
    json_data = JSON.parse(File.read("#{Rails.root}/public/data.json"))
    key ? json_data[key] : json_data
  end
end
