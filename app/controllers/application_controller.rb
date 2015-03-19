class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html

  before_filter :set_locale
  before_filter :set_in_app_browser

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
    # Only permit a key / value for language code if it is already present and valid.
    session[:language_code] = nil unless I18n.locale_available?(session[:language_code]) if session[:language_code]
    params[:language_code] = nil unless I18n.locale_available?(params[:language_code]) if params[:language_code]
    # Prefer the session's language code over parameters.
    I18n.locale = session[:language_code] || params[:language_code] || I18n.default_locale
  end

  def set_in_app_browser
    @in_app_browser = request.headers['HTTP_USER_AGENT'].include?(MOBILE_APP_USER_AGENT_STRING)
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
