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
    end
 
    socket.close
  end
  # desc 'Populates cached groups'
  # task :populate_groups => :environment do
  #   byebug
  #   groups = Group.includes([:subgroups]).all.order(:name_en)
  #   Rails.cache.write('groups', groups, expires_in: 1.day) if groups.present?
  # end

  # desc 'Checks if groups and cached groups match'
  # task :check_cached_groups_match => :environment do
  #   byebug
  #   groups = Group.includes([:subgroups]).all.order(:name_en)
  #   cached_groups = Rails.cache.read('groups')
  #   puts 'wrong number' unless cached_groups.present? and cached_groups.count == groups.count
  # end
  
  # desc 'Delete groups from cache'
  # task :delete_all_groups => :environment do
  #   Rails.cache.delete('groups')
  #   puts 'ok' if Rails.cache.read('groups') == nil
  # end
end