require 'spec_helper'

describe Elb::Deploy do
  before(:all) do
    AWS.stub!
    ensure_tmp
    @options = {
      :instance_id => instance_id,
      :noop => true,
      :restart_command => "touch tmp/restart.txt"
    }
    Elb::UI.mute = true
  end
  let(:lb) { double("Aws::Elb") }
  let(:deploy) { 
    deploy = Elb::Deploy.new(@options)
    allow(deploy.asg).to receive(:load_balancers).and_return([lb])
    allow(deploy).to receive(:wait).and_return(true)
    deploy
  }

  describe "deploy" do
    it "should run" do
      expect(deploy).to receive(:deregister)
      expect(deploy).to receive(:restart)
      expect(deploy).to receive(:warm)
      expect(deploy).to receive(:register)
      deploy.run
    end

    it "should have asg" do
      expect(deploy.asg).to_not be_nil
    end

    it "should have elb" do
      expect(deploy.elb).to_not be_nil
    end

    it "should deregister" do
      expect(deploy.deregister).to be true
    end

    it "should register" do
      expect(deploy.register).to be true
    end

    it "should restart" do
      expect(deploy.restart).to be true
    end

  end
end