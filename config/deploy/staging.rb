server 'gefc.dev-vizzuality.com', user: 'ubuntu', roles: %w{web app db}, primary: true
set :ssh_options, forward_agent: true

set :branch, 'develop'
