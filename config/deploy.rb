lock '~> 3.16.0'
set :application, 'gefc'
set :repo_url, 'git@github.com:Vizzuality/gefc-api.git'
set :deploy_to, '/var/www/gefc_api'
append :linked_files, '.env'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/downloads', 'vendor/bundle'
set :keep_releases, 3
