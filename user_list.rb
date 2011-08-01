module OpscodeAcl
  class UserList < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife user list"
    
    deps do
      require 'pp'
    end

    def run
      chef_rest = Chef::REST.new(Chef::Config[:chef_server_url])
      users = chef_rest.get_rest("users").map { |u| u["user"]["username"] }
      pp users.sort
    end
  end
end

