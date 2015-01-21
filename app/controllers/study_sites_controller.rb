require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class StudySitesController < ApplicationController
  include IMedidataClient
  before_filter :authorize_user

  def index
    params.require(:study_uuid)
    render json: uniq_name_and_uuids(request_study_sites!(params)['study_sites'])
  end
end
