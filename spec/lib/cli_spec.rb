require 'spec_helper'

describe Elb::CLI do
  before(:all) do
    ensure_tmp
    @args = "--noop --instance-id #{instance_id} --mute"
  end

  describe "elb" do
    it "should restart" do
      out = execute("bin/elb restart #{@args}")
      out.should include("Restarting server started")
      out.should include("Restarting server completed")
    end

    it "should deregister" do
      out = execute("bin/elb deregister #{@args}")
      out.should include("Deregistering server from ELB")
    end

    it "should register" do
      out = execute("bin/elb register #{@args}")
      out.should include("Registering server with ELB")
    end
  end
end