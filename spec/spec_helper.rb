ENV['TEST'] = '1'

if RUBY_VERSION != "1.8.7"
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require "pp"
 
root = File.expand_path('../../', __FILE__)
require "#{root}/lib/elb"

module Helpers
  def execute(cmd)
    puts "Running: #{cmd}" if ENV['DEBUG']
    out = `#{cmd}`
    puts out if ENV['DEBUG']
    out
  end

  def instance_id
    ENV['INSTANCE_ID']
  end

  def ensure_tmp
    FileUtils.mkdir('tmp') unless File.exist?('tmp')
  end
end

RSpec.configure do |c|
  c.include Helpers
end
