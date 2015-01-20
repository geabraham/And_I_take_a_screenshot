require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class StudySitesController < ApplicationController
  include IMedidataClient
  before_filter :authorize_user

  def index
    params.require(:study_uuid)
    render json: request_study_sites!(params)['study_sites'].uniq.collect{|ss| [ss['name'], ss['uuid']]}
  end
end
