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
      tags = ec2.describe_instances(instance_ids: [@instance_id]).reservations[0].instances[0].tags
      asg_name = ''
      tags.each do |tag|
        if tag[0] == "aws:autoscaling:groupName"
          asg_name = tag[1]
        end
      end

      @asg = asg_name
    end

    def elb_deregistration
      if asg != ''
        as = Aws::AutoScaling::Client.new()

        tgs = as.describe_load_balancer_target_groups({ auto_scaling_group_name: asg })

        if tgs[0].empty?
          lbs = as.describe_load_balancers({
            auto_scaling_group_name: asg
          })

          elb = Aws::ElasticLoadBalancing::Client.new()

          # deregister
          # 
          elb.deregister_instances_from_load_balancer({
            load_balancer_name: lbs[0][0].load_balancer_name,
            instances: [ 
              {
                instance_id: @instance_id,
              },
            ],})
        else
          elb2 = Aws::ElasticLoadBalancingV2::Client.new()

          elb2.deregister_targets({
            target_group_arn: tgs[0][0].load_balancer_target_group_arn, # required
            targets: [
              {
                id: @instance_id
              },
            ],
          })
        end
      end
    end

    def elb_registration
      if asg != ''
        as = Aws::AutoScaling::Client.new()

        tgs = as.describe_load_balancer_target_groups({ auto_scaling_group_name: asg })

        if tgs[0].empty?
          lbs = as.describe_load_balancers({
            auto_scaling_group_name: asg
          })

          elb = Aws::ElasticLoadBalancing::Client.new()

          # register
          # 
          elb.register_instances_with_load_balancer({
            load_balancer_name: lbs[0][0].load_balancer_name,
            instances: [ 
              {
                instance_id: @instance_id,
              },
            ],})
        else
          elb2 = Aws::ElasticLoadBalancingV2::Client.new()

          elb2.register_targets({
            target_group_arn: tgs[0][0].load_balancer_target_group_arn, # required
            targets: [
              {
                id: @instance_id
              },
            ],
          })
        end
      end
    end

    def deregister
      UI.say("Deregistering server from ELB")
      return true if @options[:noop]
      
      elb_deregistration

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
      elb_registration
    end

    def wait(n)
      sleep n
    end
  end
end
