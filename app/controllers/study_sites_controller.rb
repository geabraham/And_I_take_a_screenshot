require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class StudySitesController < ApplicationController
  include IMedidataClient
  before_filter :authorize_user

  def index
    params.require(:study_uuid)
    study_sites = request_study_sites!(params)['study_sites']
    add_authorizations_to_session('study_sites', study_sites.map {|ss| {uuid: ss['uuid'], name: ss['name']}})
    render json: name_uuid_options_array(study_sites)
  end
end
