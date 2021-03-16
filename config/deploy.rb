lock '~> 3.16.0'
set :application, 'gefc'
set :repo_url, 'git@github.com:Vizzuality/gefc-api.git'
set :deploy_to, '/var/www/gefc_api'
append :linked_files, '.env'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/downloads', 'vendor/bundle'
set :keep_releases, 3
set :rbenv_type, :user
set :rbenv_ruby, '3.0.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all
server 'server', port: 7171, roles: [:web, :app, :db], primary: true
set :puma_threads, [1, 16]
set :puma_workers, 0
set :puma_bind,       'unix:///var/www/gefc_api/shared/tmp/sockets/puma.sock'
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end