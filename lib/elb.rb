$:.unshift(File.expand_path("../", __FILE__))
require "elb/version"

module Elb
  autoload :CLI, 'elb/cli'
  autoload :Deploy, 'elb/deploy'
  autoload :UI, 'elb/ui'
  autoload :Helper, 'elb/helper'
  autoload :Settings, 'elb/settings'
end