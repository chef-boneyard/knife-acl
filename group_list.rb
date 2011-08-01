module OpscodeAcl
  class GroupList < Chef::Knife
    category "OPSCODE HOSTED CHEF ACCESS CONTROL"
    banner "knife group list"
    
    deps do
      require 'pp'
    end

    def run
      chef_rest = Chef::REST.new(Chef::Config[:chef_server_url])
      groups = chef_rest.get_rest("groups").keys.sort
      pp groups
    end
  end
end

