require 'casclient'
require 'casclient/frameworks/rails/filter'
require 'imedidata/client'

class StudySitesController < ApplicationController
  include IMedidataClient
  # before_filter :authorize_user

  def index
    params.require(:study_uuid)
    render json: [
      ['DeepSpaceStation', SecureRandom.uuid],
      ['GalacticQuadrantBeta', SecureRandom.uuid],
      ['GenesisPlanet', SecureRandom.uuid],
      ['StarfleetAcademy', SecureRandom.uuid]
    ]
  end
end
