$:.unshift(File.dirname(__FILE__) + '/lib')
require 'knife-acl/version'

Gem::Specification.new do |s|
  s.name = 'knife-acl'
  s.version = KnifeACL::VERSION
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.md", "LICENSE" ]
  s.summary = "ACL Knife Tools for Opscode Hosted Chef"
  s.description = s.summary
  s.author = "Seth Falcon"
  s.email = "seth@opscode.com"
  s.homepage = "http://wiki.opscode.com/display/chef"
  s.require_path = 'lib'
  s.files = %w(LICENSE README.md) + Dir.glob("lib/**/*")
end
