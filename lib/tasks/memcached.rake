require "socket"

namespace :memcached do
  desc "Flushes whole memcached local instance"
  task flush: :environment do
    server = "127.0.0.1"
    port = 11211
    command = "flush_all\r\n"

    socket = TCPSocket.new(server, port)
    socket.write(command)
    result = socket.recv(2)

    if result != "OK"
      warn "Error flushing memcached: #{result}"
    else
      warn "OK mckey"
    end

    socket.close
  end

  desc "Populate Groups and Subgroups cache"
  task populate_groups_and_subgroups: :environment do
    API::V1::FetchGroup.new.all
    API::V1::FetchSubgroup.new.all
    Group.all.each do |group|
      puts group.id
      API::V1::FetchSubgroup.new.by_group(group)
      API::V1::FetchSubgroup.new.default_by_group(group)
      API::V1::FetchSubgroup.new.default_slug_by_group(group)
    end

    Subgroup.all.each do |subgroup|
      puts subgroup.id
      API::V1::FetchIndicator.new.by_subgroup(subgroup)
      API::V1::FetchIndicator.new.default_by_subgroup(subgroup)
    end
  end

  desc "Populate Indicators cache"
  task populate_indicators: :environment do
    API::V1::FetchIndicator.new.all
    Indicator.all.each do |indicator|
      puts indicator.id
      API::V1::FetchIndicator.new.records(indicator)
    end
  end

  desc "Populate regions cache"
  task populate_regions: :environment do
    API::V1::FetchRegion.new.all
  end

  desc "Populate all cache"
  task populate_all: :environment do
    API::V1::FetchGroup.new.all
    API::V1::FetchSubgroup.new.all
    Group.all.each do |group|
      puts group.id
      API::V1::FetchSubgroup.new.by_group(group)
      API::V1::FetchSubgroup.new.default_by_group(group)
      API::V1::FetchSubgroup.new.default_slug_by_group(group)
    end

    Subgroup.all.each do |subgroup|
      puts subgroup.id
      API::V1::FetchIndicator.new.by_subgroup(subgroup)
      API::V1::FetchIndicator.new.default_by_subgroup(subgroup)
    end

    API::V1::FetchIndicator.new.all
    Indicator.all.each do |indicator|
      puts indicator.id
      API::V1::FetchIndicator.new.records(indicator)
    end

    API::V1::FetchRegion.new.all
  end
end
