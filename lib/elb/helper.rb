require 'aws-sdk'

module Elb
  module Helper
    @@setup_aws = nil
    def setup_aws(region='us-east-1', options={})
      return if @@setup_aws
      path = Elb::Settings.new.aws_path
      if File.exist?(path)
        @config = YAML.load(IO.read(path))
        Aws.config.update({
          region: region,
          credentials: Aws::Credentials.new(@config[:aws_access_key_id], @config[:aws_secret_access_key])
        })
      end
      @@setup_aws = true
    end

    def ec2
      @ec2 ||= Aws::EC2::Client.new
    end

    # def cfn
    #   @cfn ||= AWS::CloudFormation.new
    # end

    # def rds
    #   @rds ||= AWS::RDS.new
    # end

    def as
      @as ||= Aws::AutoScaling::Client.new()
    end

    # def r53
    #   @r53 ||= AWS::Route53.new
    # end

  end
end
