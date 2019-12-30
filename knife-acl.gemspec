$:.unshift(File.dirname(__FILE__) + "/lib")
require "knife-acl/version"

Gem::Specification.new do |s|
  s.name = "knife-acl"
  s.version = KnifeACL::VERSION
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["LICENSE" ]
  s.summary = "Knife plugin to manupulate Chef server access control lists"
  s.description = s.summary
  s.authors = [ "Seth Falcon", "Jeremiah Snapp" ]
  s.email = "support@chef.io"
  s.homepage = "https://github.com/chef/knife-acl"
  s.require_path = "lib"
  s.files = %w{LICENSE} + Dir.glob("lib/**/*")
end
