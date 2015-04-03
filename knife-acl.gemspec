$:.unshift(File.dirname(__FILE__) + '/lib')
require 'knife-acl/version'

Gem::Specification.new do |s|
  s.name = 'knife-acl'
  s.version = KnifeACL::VERSION
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.md", "LICENSE" ]
  s.summary = "Knife plugin to manupulate Chef server access control lists"
  s.description = s.summary
  s.author = "Seth Falcon"
  s.email = "support@chef.io"
  s.homepage = "https://github.com/chef/knife-acl"
  s.require_path = 'lib'
  s.files = %w(LICENSE README.md) + Dir.glob("lib/**/*")
end
