class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html

  before_filter :set_locale

  ERROR_CAUSE = {
    ActionController::UnpermittedParameters => :unprocessable_entity,
    ActionController::ParameterMissing => :unprocessable_entity,
    PatientManagementPermissionsHelper::PermissionsError => :not_found,
    IMedidataClient::IMedidataClientError => :not_found,
    Euresource::ResourceNotFound => :not_found,
    Faraday::Error::ConnectionFailed => :service_unavailable }

  rescue_from StandardError, with: :rescue_error_minotaur

  def logout
    reset_session
    redirect_to CASClient::Frameworks::Rails::Filter.client.logout_url
  end

  def routing_error
    raise ActionController::RoutingError.new("No route matches #{params[:path]}")
  end

  protected

  def impersonate_header
    {'X-MWS-Impersonate' => params[:user_uuid]}
  end

  # Set user's locale from request, assuming it comes from Checkmate.
  #TODO in future locale may be in header instead of params, depending on Checkmate
  def set_locale
    # Prefer the session's language code over the one set in params.
    session[:language_code] = I18n.locale_available?(session[:language_code]) ? session[:language_code] : nil
    params[:language_code] = I18n.locale_available?(params[:language_code]) ? params[:language_code] : nil
    I18n.locale = session[:language_code] || params[:language_code] || I18n.default_locale
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

  def rescue_error_minotaur(exception)
    @error = true
    status_code(ERROR_CAUSE[exception.exception.class])
    render_error(exception)
  end

  def status_code(reason_phrase_symbol = :internal_server_error)
    @status_code ||= Rack::Utils::SYMBOL_TO_STATUS_CODE[reason_phrase_symbol]
  end

  def render_error(exception = nil)
    render json: {errors: exception.try(:message)}, status: status_code
  end
end
