class SandmanController < ApplicationController
  def index
  end

  def mixins
    @mixins_data = get_json_data('mixins')
  end

  def panel
  end

  def generator
  end

  def validate
  end

  def asset_sync
  end

  def forms
  end

  def sidebar
  end

  def buttons
  end

  def platform_layout
  end

  def icons
  end

  def modal
  end

  def select2
    @prez = presidents
  end

  def select2_api
    @filtered_prez = presidents.find_all do |prez|
      prez[:text].downcase.include?((params['query'] || '').downcase)
    end
    render json: @filtered_prez
  end

  def underscore
  end

  def cdn
  end

private
  def presidents
    YAML.load(File.read(Rails.root.join('config', 'executive.yaml'))).map do |p|
      {id: p['id']['bioguide'], text: p['name']['first'] + ' ' + p['name']['last'], orig: p}
    end
  end
end
