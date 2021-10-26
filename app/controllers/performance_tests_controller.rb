class PerformanceTestsController < ActionController::Base
  before_action do
    Rack::MiniProfiler.authorize_request
  end

  def index
  end
end
