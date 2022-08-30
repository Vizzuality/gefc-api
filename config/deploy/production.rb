server "13.213.203.116", user: "ubuntu", roles: %w[web app db], primary: true
set :ssh_options, forward_agent: true
set :branch, "main"
