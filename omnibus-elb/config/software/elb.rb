#
# Copyright 2016 YOUR NAME
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# These options are required for all software definitions
name "elb"
default_version "0.0.8"

dependency "ruby"
dependency "bundler"
dependency "rubygems"
dependency "appbundler"
dependency "nokogiri"

env = {
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}",
  "PKG_CONFIG_PATH" => "#{install_dir}/embedded/lib/pkgconfig",
  "LD_FLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "LD_LIBRARY_PATH" => "#{install_dir}/embedded/lib",
  "NOKOGIRI_USE_SYSTEM_LIBRARIES" => "1"
}

source path: "../"

build do
  bundle "install --path vendor/bundle", :env => env

  gem "build elb.gemspec", :env => env
  # gem "install json rake"
  gem "install elb*.gem --no-ri --no-rdoc", :env => env
  gem "install elb -n #{install_dir}/bin --no-rdoc --no-ri -v #{default_version}"

   appbundle "elb"
end
