require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/puma'
require 'capistrano/bundler'
require 'capistrano/scm/git'

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
set :rbenv_ruby, '3.0.0p0'

install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma, load_hooks: true
install_plugin Capistrano::Puma::Systemd

require "capistrano/rails"

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
