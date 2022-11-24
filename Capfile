# frozen_string_literal: true

require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/rbenv"
require "capistrano/bundler"
require "capistrano/scm/git"
require "capistrano/sidekiq"

set :rbenv_prefix,
  "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_roles, :all # default value
set :rbenv_ruby, "3.0.0p0"

install_plugin Capistrano::SCM::Git

require "capistrano/rails"
require "capistrano/passenger"
require "capistrano-yarn"
# require "capistrano/rails/migrations"

install_plugin Capistrano::Sidekiq  # Default sidekiq tasks
# Then select your service manager
install_plugin Capistrano::Sidekiq::Systemd

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

require "appsignal/capistrano"
