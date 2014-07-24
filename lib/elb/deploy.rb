module Elb
  class Deploy
    include Helper

    attr_reader :instance_id
    def initialize(options={})
      @options = options
      @instance_id = options[:instance_id] || %x[curl -s http://instance-data.ec2.internal/latest/meta-data/instance-id].strip
      setup_aws
    end

    def run
      UI.say("Restarting server started")
      deregister
      drop_inbound
      restart
      warm
      add_inbound
      register
      UI.say("Restarting server completed")
    end

    def asg
      return @asg if @asg
      name = ec2.instances[instance_id].tags["aws:autoscaling:groupName"]
      @asg = as.groups[name]
    end

    def elb
      return @elb if @elb
      @elb = asg.load_balancers.first
    end

    def deregister
      UI.say("Deregistering server from ELB")
      return true if @options[:noop]
      elb.client.deregister_instances_from_load_balancer(
        :load_balancer_name => elb.name,
        :instances => [{:instance_id => @instance_id}]
      )
      wait(@options[:wait]) # takes a while for the elb to deregister
    end

    def drop_inbound
      %x{sudo /sbin/iptables -A INPUT -j DROP -p tcp --destination-port 80 -i eth0}
    end

    def add_inbound
      %x{sudo /sbin/iptables -D INPUT -j DROP -p tcp --destination-port 80 -i eth0}
    end


    def restart
      UI.say("Restarting server")
      system(@options[:restart_command])
    end

    def warm
      UI.say("Warming up server")
      system(@options[:warm_command])
    end

    def register
      UI.say("Registering server with ELB")
      return true if @options[:noop]
      elb.client.register_instances_with_load_balancer(
        :load_balancer_name => elb.name,
        :instances => [{:instance_id => @instance_id}]
      )
    end

    def wait(n)
      sleep n
    end
  end
end
