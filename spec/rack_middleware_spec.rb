require 'spec_helper'

describe 'Rack Middleware' do
  it 'uses the platform cross application tracing rack middleware' do
    expect(include_middleware?(CrossApplicationTracer::RackHandler)).to be true
  end

  it 'uses the platform logging rack middleware' do
    expect(include_middleware?(Astinus::SetRequestInfo)).to be true
  end

  it 'places the cross application tracer middleware upstream of the platform logging middleware' do
    expect(ordering_correct?(CrossApplicationTracer::RackHandler, Astinus::SetRequestInfo)).to be true
  end

  it 'places the cross application tracer middleware downstream of Rack::Runtime' do
    expect(ordering_correct?(Rack::Runtime, CrossApplicationTracer::RackHandler)).to be true
  end

  def ordering_correct?(upstream_middleware, downstream_middleware)
    include_middleware?(upstream_middleware) && include_middleware?(downstream_middleware) &&
      (index_of_rack_middleware(upstream_middleware) < index_of_rack_middleware(downstream_middleware))
  end

  def include_middleware?(middleware_klass)
    index_of_rack_middleware(middleware_klass).present?
  end

  def index_of_rack_middleware(middleware_klass)
    Rails.application.config.middleware.find_index(middleware_klass)
  end
end
