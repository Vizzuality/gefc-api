server 'ec2-13-229-92-127.ap-southeast-1.compute.amazonaws.com', user: 'ubuntu', roles: %w{web app db}, primary: true
set :ssh_options, forward_agent: true

set :branch, 'develop'
