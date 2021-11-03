require 'socket'

namespace :memcached do
  desc 'Flushes whole memcached local instance'
  task :flush => :environment do
    server  = '127.0.0.1'
    port    = 11211
    command = "flush_all\r\n"
 
    socket = TCPSocket.new(server, port)
    socket.write(command)
    result = socket.recv(2)
 
    if result != 'OK'
      STDERR.puts "Error flushing memcached: #{result}"
    else
      STDERR.puts "OK mckey"
    end
 
    socket.close
  end
  desc 'Populates cached groups'
  task :populate_groups => :environment do
    groups = Group.includes([:subgroups]).all.order(:name_en)
    Rails.cache.write('groups', groups, expires_in: 1.day) if groups.present?
  end

  desc 'Checks if groups and cached groups match'
  task :check_cached_groups_match => :environment do
    groups = Group.includes([:subgroups]).all.order(:name_en)
    cached_groups = Rails.cache.read('groups')
    puts 'wrong number' unless cached_groups.present? and cached_groups.count == groups.count
    puts 'OK' if cached_groups.present? and cached_groups.count == groups.count
  end
  
  desc 'Delete groups from cache'
  task :delete_all_groups => :environment do
    Rails.cache.delete('groups')
    puts 'ok' if Rails.cache.read('groups') == nil
  end

  desc 'Populate Groups and Subgroups cache'
  task :populate_groups_and_subgroups => :environment do
    API::V1::FetchGroup.new.all
    API::V1::FetchSubgroup.new.all
    Group.all.each do |group|
      puts group.id
      API::V1::FetchSubgroup.new.by_group(group)
      API::V1::FetchSubgroup.new.default_by_group(group)
      API::V1::FetchSubgroup.new.default_slug_by_group(group)
      API::V1::FetchGroup.new.header_image_url(group)   
    end

    Subgroup.all.each do |subgroup|
      puts subgroup.id
      API::V1::FetchIndicator.new.by_subgroup(subgroup)
      API::V1::FetchIndicator.new.default_by_subgroup(subgroup)
    end
  end

  desc 'Populate Indicators cache'
  task :populate_indicators => :environment do
    API::V1::FetchIndicator.new.all
    Indicator.all.each do |indicator|
      puts indicator.id
      API::V1::FetchIndicator.new.default_visualization(indicator)
      API::V1::FetchIndicator.new.default_widget(indicator)
      API::V1::FetchIndicator.new.widgets(indicator)
      API::V1::FetchIndicator.new.widgets_list(indicator)
      API::V1::FetchIndicator.new.records(indicator)
      API::V1::FetchIndicator.new.scenarios(indicator)
      API::V1::FetchIndicator.new.regions(indicator)
      API::V1::FetchIndicator.new.category_1(indicator)
      API::V1::FetchIndicator.new.category_filters(indicator)
      API::V1::FetchIndicator.new.start_date(indicator)
      API::V1::FetchIndicator.new.end_date(indicator)
      API::V1::FetchIndicator.new.group(indicator)
      API::V1::FetchIndicator.new.subgroup(indicator)
    end
  end

  desc 'Populate records cache'
  task :populate_records => :environment do
    Record.all.each do |record|
      puts record.id
      API::V1::FetchRecord.new.unit(record)
      API::V1::FetchRecord.new.region(record)
      API::V1::FetchRecord.new.scenario(record)
      API::V1::FetchRecord.new.widgets(record)
      API::V1::FetchRecord.new.widgets_list(record)
    end
  end
end