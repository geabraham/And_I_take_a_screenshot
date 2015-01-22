class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html

  before_filter :set_locale

  ERROR_CAUSE = {
    ActionController::UnpermittedParameters => :unprocessable_entity,
    IMedidataClient::IMedidataClientError => :unauthorized }

  rescue_from "StandardError" do |e|
    error_cause ||= ERROR_CAUSE[e.exception.class] || :unprocessable_entity
    render json: {errors: e.message}, status: error_cause
  end

  protected
  # Set user's locale from request, assuming it comes from Checkmate.
  #TODO in future locale may be in header instead of params, depending on Checkmate
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def authorize_user
    # Redirects to login page if there is no active session
    #
    if CASClient::Frameworks::Rails::Filter.filter(self)
      @user_email = session[:cas_extra_attributes]['user_email']
      params.merge!(user_uuid: session[:cas_extra_attributes]['user_uuid'])
    end
  end

  def name_uuid_options_array(collection)
    collection.uniq.collect { |s| [s['name'], s['uuid']] }
  end
end
