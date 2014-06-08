require 'spec_helper'

describe Elb::CLI do
  before(:all) do
    ensure_tmp
    @args = "--noop --instance-id #{instance_id} --mute"
  end

  describe "elb" do
    it "should restart" do
      out = execute("bin/elb restart #{@args}")
      expect(out).to include("Restarting server started")
      expect(out).to include("Restarting server completed")
    end

    it "should deregister" do
      out = execute("bin/elb deregister #{@args}")
      expect(out).to include("Deregistering server from ELB")
    end

    it "should register" do
      out = execute("bin/elb register #{@args}")
      expect(out).to include("Registering server with ELB")
    end
  end
end