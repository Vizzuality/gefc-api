require 'socket'
 
namespace :memcached do
  desc 'Flushes whole memcached local instance'
  task :flush do
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
end