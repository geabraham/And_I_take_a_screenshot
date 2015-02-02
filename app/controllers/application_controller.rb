class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html

  before_filter :set_locale

  ERROR_CAUSE = {
    ActionController::UnpermittedParameters => :unprocessable_entity,
    IMedidataClient::IMedidataClientError => :unauthorized,
    Euresource::ResourceNotFound => :not_found }

  rescue_from "StandardError" do |e|
    error_cause ||= ERROR_CAUSE[e.exception.class] || :unprocessable_entity
    render json: {errors: e.message}, status: error_cause
  end

  def logout
    reset_session
    redirect_to CASClient::Frameworks::Rails::Filter.client.logout_url
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

  # Adds to session[:cas_extra_attributes][:authorized_object_type] << object
  # E.g.: session[:cas_extra_attributes]
  # => {user_id:'1',
  #     user_uuid:'0e39dd40-9fe2-11df-a531-12313900d531',
  #     user_email:'helper_1@example.com',
  #     authorized_study_sites: [{uuid: '161332d2-9fe2-11df-a531-12313900d531', name: 'Alfred Hospital'}]}
  #
  def add_authorizations_to_session(object_type, objects)
    authorized_objects = "authorized_#{object_type}".to_sym
    user_session[authorized_objects] ||= []
    objects.uniq.each do |object|
      user_session[authorized_objects] << object unless user_session[authorized_objects].include?(object)
    end
  end

  def user_session
    session[:cas_extra_attributes]
  end
end
