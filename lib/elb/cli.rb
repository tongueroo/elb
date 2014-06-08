require 'thor'
require 'elb/cli/help'

module Elb

  class CLI < Thor
    class_option :noop, :type => :boolean
    class_option :mute, :default => false, :type => :boolean
    class_option :instance_id, :desc => 'instance id to use, defaults to instance command is running on'

    desc "restart", "restart server"
    long_desc Help.restart
    option :wait, :type => :numeric, :default => 20, :desc => 'period to wait after deregistering'
    option :warm_command, :desc => 'command use to warm app, defaults to curling homepage', :default => "curl -s -v -o /dev/null localhost/ 2>&1 | grep '< HTTP'"
    option :restart_command, :desc => 'command use to restart app, defaults to touch tmp/restart.txt', :default => "touch tmp/restart.txt"
    def restart
      Deploy.new(options).run
    end

    desc "deregister", "deregister server from elb"
    def deregister
      Deploy.new(options.merge(:wait => 0)).deregister
    end

    desc "register", "register server with elb"
    def register
      Deploy.new(options).register
    end
  end
end