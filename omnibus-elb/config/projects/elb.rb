#
# Copyright 2016 YOUR NAME
#
# All Rights Reserved.
#

name "elb"
maintainer "Benson Wu"
homepage "https://github.com/tongueroo/elb"

# Defaults to C:/elb on Windows
# and /opt/elb on all other platforms
install_dir "#{default_root}/#{name}"

build_version Omnibus::BuildVersion.semver
build_iteration 1

# Creates required build directories
dependency "elb"
dependency "ruby"

override :ruby, version: '2.2.5'

package :deb do
  vendor 'Bleacher Report <ops@bleacherreport.com>'
  priority 'extra'
end

# elb dependencies/components
# dependency "somedep"

# Version manifest file
# dependency "version-manifest"

exclude "**/.git"
exclude "**/bundler/git"
