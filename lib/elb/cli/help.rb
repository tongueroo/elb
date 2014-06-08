module Elb
  class CLI < Thor
    class Help
      class << self
        def restart
<<-EOL
The command is meant to be ran on the instance itself and will basically:

1. deregister the instance from the autoscaling group it's associated with

2. restart the app

3. warm up the app by hitting it with a local curl request

4. register the instance back to the elb

Examples:

$ elb restart --wait 30 # wait 30 seconds after deregistering

$ elb restart --warm-command "curl -s -v -o /dev/null localhost/custom-warm-url 2>&1 | grep '< HTTP'"

$ elb restart --restart-command "/etc/init.d/nginx restart"
EOL
        end
      end
    end
  end
end