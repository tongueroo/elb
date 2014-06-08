guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})      { "spec/elb_spec.rb" }
  watch(%r{^lib/elb/(.+)\.rb$})  { "spec/elb_spec.rb" }
  watch('spec/spec_helper.rb')   { "spec/elb_spec.rb" }
  watch(%r{^lib/elb/(.+)\.rb$})   { |m| "spec/lib/#{m[1]}_spec.rb" }
end

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end