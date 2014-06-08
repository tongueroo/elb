require 'yaml'
require 'hashie'

module Elb
  class Settings
    def aws_path
      path = ENV['TEST'] ? "spec/fixtures/aws.yml" : "#{br_path}/aws.yml"
      path = ENV['AWS'] if ENV['AWS']
      path
    end

    def br_path
      self.class.br_path
    end

    def self.br_path
      ENV['BR_PATH'] || "#{ENV['HOME']}/.br"
    end

    def self.setup_br_path
      FileUtils.mkdir(br_path) unless File.exist?(br_path)
    end
  end
end

Elb::Settings.setup_br_path