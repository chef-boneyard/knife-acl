$:.unshift(File.dirname(__FILE__) + '/lib')
require 'knife-acl/version'

Gem::Specification.new do |s|
  s.name = 'knife-acl'
  s.version = KnifeACL::VERSION
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.md", "LICENSE" ]
  s.summary = "ACL Knife Tools for Opscode hosted Enterprise Chef/Enterprise Chef"
  s.description = s.summary
  s.author = "Seth Falcon"
  s.email = "support@opscode.com"
  s.homepage = "https://github.com/opscode/knife-acl/blob/master/README.md"
  s.require_path = 'lib'
  s.files = %w(LICENSE README.md) + Dir.glob("lib/**/*")
end
