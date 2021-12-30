namespace :varnish do
  desc 'Flushes Varnish'
  task :clear_all => :environment do
    API_HOST = ENV['API_HOST']
    regexp = '^/api/v1/'
    with_uri(API_HOST) do |uri|
      Rails.logger.debug "Banning: #{regexp}"
      request = Net::HTTP::Ban.new uri.request_uri
      request['x-invalidate-pattern'] = regexp
      request
    end
  end

  task :clear_by_url => :environment do
    url = ENV['url']
    with_uri(url) do |uri|
      Rails.logger.debug "Purging: #{uri}"
      Net::HTTP::Purge.new uri.request_uri
    end
  end

  def with_uri(url)
    return unless Rails.env.staging? || Rails.env.production?
    uri = URI(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = yield(uri)
      response = http.request request
      puts "#{response.code}: #{response.message}"
      Rails.logger.debug "#{response.code}: #{response.message}"
      unless (200...400).cover?(response.code.to_i)
        Rails.logger.error 'A problem occurred. Operation was not performed.'
      end
    end
  rescue => e
    Appsignal.send_error(e)
  end
end
