set :application, "gefc"

set :repo_url, "git@github.com:Vizzuality/gefc-api.git"
set :deploy_to, "/var/www/gefc_api"

append :linked_files, ".env", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/downloads", "vendor/bundle"

set :keep_releases, 3
set :rbenv_type, :user
set :rbenv_ruby, "3.0.0"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_roles, :all
