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

end
