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
    deploy.asg.stub(:load_balancers).and_return([lb])
    deploy.stub(:wait).and_return(true)
    deploy
  }

  describe "deploy" do
    it "should run" do
      deploy.should_receive(:deregister)
      deploy.should_receive(:restart)
      deploy.should_receive(:warm)
      deploy.should_receive(:register)
      deploy.run
    end

    it "should have asg" do
      deploy.asg.should_not be_nil
    end

    it "should have elb" do
      deploy.elb.should_not be_nil
    end

    it "should deregister" do
      deploy.deregister.should == true
    end

    it "should register" do
      deploy.register.should == true
    end

    it "should restart" do
      deploy.restart.should == true
    end

  end
end